const { bot } = require('../bot');

let users = {};
let pendingAuths = {};

// нажатие на кнопку авторизации
bot.action('auth_click', async (ctx) => {
   const userId = ctx.from.id;

   if (!pendingAuths[userId]) {
      await ctx.answerCbQuery('Ошибка: процесс авторизации не найден или уже завершен');
      await ctx.deleteMessage().catch(err => {
         console.error('Ошибка при удалении сообщения (ошибка авторизации):', err);
      });
      return;
   }

   await ctx.deleteMessage().catch(err => {
      console.error('Ошибка при удалении сообщения:', err);
   });

   pendingAuths[userId].step = 'awaiting_password';

   await ctx.reply('Введите логин и пароль в одном сообщении через пробел.\n(Пример: `mymail@mail.ru pass123`)');
});

/* обработка активной авторизации */

bot.use(async (ctx, next) => {
   const userId = ctx.from?.id;
   const state = pendingAuths[userId];

   // если не в состоянии ожидания пароля - выходим
   if (!state || state.step !== 'awaiting_password') {
      return await next(); // пропускаем дальше
   }

   // получили сообщение пользователя
   const message = ctx.message;
   const entered = message?.text;

   // если пустое (и прочие проверки) - выход
   if (!entered || !entered.includes(' ')) return;

   const [login, password] = entered.split(' '); // базовый разбор логина и пароля

   // здесь запрос серверу
   const isValid = (login === 'mylogin') && (password === 'pass123');

   // если сервер вернул положительный ответ
   if (isValid) {
      // сохранение в массив авторизованных юзеров
      users[userId] = { name: ctx.from.first_name };

      // приветствие и прочие важные вещи для тг
      await ctx.reply(`Добро пожаловать, ${users[userId].name}!`);

      clearTimeout(state.timeoutId);
      const nextFn = state.next;

      delete pendingAuths[userId];

      if (nextFn) await nextFn();

   // иначе - выход
   } else {
      // удаляем сообщение с логином и паролем
      await ctx.deleteMessage(message.message_id).catch(err => {
         console.error('Не удалось удалить сообщение с паролем:', err);
      });

      // сообщение о неудаче
      await ctx.reply('Неверный логин или пароль. Попробуйте снова через кнопку авторизации.');

      delete pendingAuths[userId];
   }
});

// обработка попытки авторизации
const handleAuthorization = (ctx, next) => {
   const userId = ctx.from.id;

   if (pendingAuths[userId]) {
      return;
   }

   pendingAuths[userId] = {
      isAuthorized: false,
      next,
      step: 'waiting_click',
   };

   pendingAuths[userId].timeoutId = setTimeout(() => {
      if (pendingAuths[userId] && !pendingAuths[userId].isAuthorized) {
         delete pendingAuths[userId];
      }
   }, 20 * 1000); // 20 секунд на истечение срока действия текущей авторизации
};

// входная точка авторизации, срабатывает в случае когда пользователь не авторизован
const authMiddleware = async (ctx, next) => {
   const userId = ctx.from.id;

   // здесь можно было бы проверять, сохранен ли userID в базе
   // чтобы пользователь не проходил авторизацию повторно при перезапуске бота,

   if (users[userId]) {
      return await next();
   }

   // создаем сообщение с кнопкой
   await ctx.reply('Пожалуйста, авторизуйтесь', {
      reply_markup: {
         inline_keyboard: [
            [{ text: 'Авторизоваться', callback_data: 'auth_click' }]
         ],
      },
   });

   // вызываем обработку авторизации
   handleAuthorization(ctx, next);
};

module.exports = { authMiddleware };