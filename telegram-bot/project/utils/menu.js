const { bot } = require('../bot');
const { Markup } = require('telegraf');
const { authMiddleware } = require('../middleware/auth');

class MenuButton {
   constructor(name, position, method, requiresAuth = false, triggers = [], command = null) {
      this.name = name;
      this.position = position;
      this.method = method;
      this.requiresAuth = requiresAuth;
      this.triggers = triggers;
      this.command = command;

      if (method === null) {
         this.method = (ctx) => ctx.reply('Не реализовано');
      }
   }

   registerTriggers(bot) {
      this.triggers.forEach(trigger => {
         if (this.requiresAuth) {
            bot.hears(trigger, authMiddleware, ctx => this.method(ctx));
         } else {
            bot.hears(trigger, ctx => this.method(ctx));
         }
      });
   }

   registerCommand(bot) {
      if (this.command) {
         bot.command(this.command, ctx => {
            if (this.requiresAuth)
               return authMiddleware(ctx, () => this.method(ctx));
            return this.method(ctx);
         });
      }
   }
}

class Menu {
   constructor() {
      this.buttons = [];
   }

   addButton(name, position, method = null, requiresAuth = false, triggers = [], command = null) {

      const button = new MenuButton(name, position, method, requiresAuth, triggers, command);
      this.buttons.push(button);
   }

   // построение клавиатуры
   buildKeyboard() {
      const keyboard = [];
      this.buttons.forEach(button => {
         const { position, name } = button;
         while (keyboard.length <= position[0])
            keyboard.push([]);
         keyboard[position[0]][position[1]] = button.name;
      });
      return keyboard;
   }

   // отрисовка построенной клавиатуры
   async drawMenu(ctx) {
      const keyboard = this.buildKeyboard();
      await ctx.reply('Внизу появилась клавиатура-меню с доступными Вам действиями.', {
         reply_markup: {
            keyboard: keyboard,
            resize_keyboard: true,
            one_time_keyboard: false,
         },
      });
   }

   registerTriggers(bot) {
      this.buttons.forEach(button => {
         if (button.method instanceof Function) {
            button.registerCommand(bot);
            button.registerTriggers(bot);
         }
      });
   }

   triggerFromMessage(ctx) {
      if (!ctx.message || !ctx.message.text)
         return false;

      const text = ctx.message.text.toLowerCase();
      for (const button of this.buttons) {
         if (button.triggers.some(trigger => text.includes(trigger.toLowerCase()))) {
            if (typeof button.method === 'function') {
               button.method(ctx);
               return true;
            }
         }
      }

      return false;
   }

   triggerFromCallbackQuery(ctx) {
      const data = ctx.callbackQuery?.data;
      if (!data) return false;

      for (const button of this.buttons) {
         if (button.command === data) {
            if (typeof button.method === 'function') {
               button.method(ctx);
               return true;
            }
         }
      }

      return false;
   }

}

// клавиатура в сообщении
class MessageKeyboard {
   constructor() {
      this.buttons = [];
   }

   addButton(label, callbackData) {
      this.buttons.push(Markup.button.callback(label, callbackData));
   }

   createGrid() {
      return Markup.inlineKeyboard(this.buttons);
   }
}

// меню в сообщении
class MessageMenu {
   constructor(rows, columns) {
      this.keyboard = new MessageKeyboard();
      this.currentMessageId = null;
      this.currentChatId = null;
      this.rows = rows;
      this.columns = columns;
   }

   addButton(label, callbackData, action) {
      this.keyboard.addButton(label, callbackData);
      bot.action(callbackData, (ctx) => {
         action(ctx);
         this.currentChatId = ctx.chat.id;
         this.currentMessageId = ctx.callbackQuery.message.message_id;
      });
   }

   async editMessage(text) {
      if (!this.currentChatId || !this.currentMessageId) {
         console.error('Chat ID или Message ID отсутствуют:', this.currentChatId, this.currentMessageId);
         return;
      }

      if (typeof text !== 'string' || text.trim() === '') {
         console.error('Неверный текст для редактирования:', text);
         return;
      }

      const keyboard = this.keyboard.createGrid();
      await bot.telegram.editMessageText(
         this.currentChatId,
         this.currentMessageId,
         undefined,
         text,
         { reply_markup: keyboard.reply_markup }
      ).catch(err => {
         console.error('Ошибка при редактировании сообщения:', err);
      });
   }

   updateMenu(text, newButtons) {
      this.keyboard = new MessageKeyboard();
      newButtons.forEach(({ label, callbackData, action }) => {
         this.addButton(label, callbackData, action);
      });
      this.editMessage(text);
   }

   clearKeyboard(ctx) {
      ctx.editMessageReplyMarkup({ inline_keyboard: [] }).catch(err => {
         console.error('Ошибка при очистке клавиатуры:', err);
      });
   }

   sendMessage(ctx, text) {
      const keyboard = this.keyboard.createGrid();
      ctx.reply(text, { reply_markup: keyboard.reply_markup })
         .then((message) => {
            this.currentMessageId = message.message_id;
            this.currentChatId = ctx.chat.id;
         })
         .catch((error) => {
            console.error('Ошибка при отправке сообщения:', error);
         });
   }

   // Новый метод для выбора строк и столбцов
   createGridSelection(rows, columns, callback) {
      const buttons = Array.from({ length: rows }, (_, rowIndex) =>
         Array.from({ length: columns }, (_, colIndex) => ({
            label: `Row ${rowIndex + 1} Col ${colIndex + 1}`,
            callbackData: `row_${rowIndex}_col_${colIndex}`,
            action: callback
         }))
      );

      buttons.forEach(row => {
         this.keyboard.addRow(row.map(button => ({
            text: button.label,
            callback_data: button.callbackData,
         })));
      });

      buttons.forEach(row => {
         row.forEach(button => {
            this.addButton(button.label, button.callbackData, (ctx) => {
               button.action(ctx); // Вызов действия
            });
         });
      });
   }
}

module.exports = { MenuButton, Menu, MessageMenu }