const { Menu } = require('../utils/menu');
const { bot } = require('../bot');

// --- Эмуляция "базы данных" ---
const userBalances = {};           // баланс пользователя
const userVipStatus = {};          // например: { [userId]: 'vip_1' }
const userSubscriptions = {};      // например: { [userId]: true }

const vipPrices = {
  vip_1: 20,
  vip_2: 50,
  vip_3: 100,
};

// --- Команда помощи ---
const help = (ctx) => {
  ctx.reply(`
- /help ("Помощь" в меню): показывает список доступных команд.
- /draw ("Нарисовать" в меню): генерация изображения по текстовому описанию.
- "Мой баланс": проверка текущего баланса.
- "Купить ВИП статус": покупка привилегий.
- "Подписаться/Отписаться от уведомлений": управление подпиской.
- "Проверить ВИП статус": отображает текущий уровень.
  `);
};

// --- Функция: Мой баланс ---
const getBalance = async (ctx) => {
  const userId = ctx.from.id;
  const balance = userBalances[userId] || 0;
  await ctx.reply(`Ваш текущий баланс: ${balance} монет.`);
};

// --- Функция: Купить VIP ---
const buyVip = async (ctx) => {
  await ctx.reply('Выберите уровень ВИП:', {
    reply_markup: {
      inline_keyboard: [
        [
          { text: 'Первый ВИП', callback_data: 'vip_1' },
          { text: 'Второй ВИП', callback_data: 'vip_2' },
          { text: 'Третий ВИП', callback_data: 'vip_3' },
        ],
      ],
    },
  });
};

const handleVipSelection = async (ctx) => {
  const userId = ctx.from.id;
  const vipKey = ctx.callbackQuery.data;
  const price = vipPrices[vipKey] || 0;
  const userBalance = userBalances[userId] || 0;

  let vipName;
  switch (vipKey) {
    case 'vip_1': vipName = 'Первый ВИП'; break;
    case 'vip_2': vipName = 'Второй ВИП'; break;
    case 'vip_3': vipName = 'Третий ВИП'; break;
    default: vipName = 'Неизвестный'; break;
  }

  if (userBalance < price) {
    await ctx.editMessageText(`❌ Недостаточно средств для покупки "${vipName}".\n💰 Требуется: ${price}, у вас: ${userBalance}.`);
  } else {
    // Списываем баланс и сохраняем статус
    userBalances[userId] = userBalance - price;
    userVipStatus[userId] = vipKey;

    await ctx.editMessageText(`✅ Поздравляем! У вас активирован статус "${vipName}".`);
  }
  await ctx.answerCbQuery();
};

// --- Функция: Подписаться на уведомления ---
const subscribe = async (ctx) => {
  const userId = ctx.from.id;
  const hasVip = !!userVipStatus[userId];

  if (!hasVip) {
    const text = '❌ У вас нет ВИП-статуса. Оформите ВИП, чтобы подписаться на уведомления.';
    try {
      if (ctx.callbackQuery?.message) {
        await ctx.editMessageText(text);
      } else {
        await ctx.reply(text);
      }
    } catch (e) {
      await ctx.reply(text);
    }
    await ctx.answerCbQuery?.();
    return;
  }

  userSubscriptions[userId] = true;
  const success = '✅ Вы подписались на уведомления.';
  try {
    if (ctx.callbackQuery?.message) {
      await ctx.editMessageText(success);
    } else {
      await ctx.reply(success);
    }
  } catch (e) {
    await ctx.reply(success);
  }
  await ctx.answerCbQuery?.();
};

// --- Функция: Отписаться от уведомлений ---
const unsubscribe = async (ctx) => {
  const userId = ctx.from.id;
  const hasVip = !!userVipStatus[userId];

  if (!hasVip) {
    const text = '❌ У вас нет ВИП-статуса. Подписка доступна только для ВИП-пользователей.';
    try {
      if (ctx.callbackQuery?.message) {
        await ctx.editMessageText(text);
      } else {
        await ctx.reply(text);
      }
    } catch (e) {
      await ctx.reply(text);
    }
    await ctx.answerCbQuery?.();
    return;
  }

  delete userSubscriptions[userId];
  const success = '✅ Вы отписались от уведомлений.';
  try {
    if (ctx.callbackQuery?.message) {
      await ctx.editMessageText(success);
    } else {
      await ctx.reply(success);
    }
  } catch (e) {
    await ctx.reply(success);
  }
  await ctx.answerCbQuery?.();
};

// --- Создание меню ---
const menu = new Menu();
menu.addButton('💰 Мой баланс',               [1, 0], getBalance,      false, ['баланс','/balance'],        'balance');
menu.addButton('🌟 Купить ВИП статус',        [1, 1], buyVip,          false, ['вип','/vip'],               'vip');
menu.addButton('🔔 Подписаться на уведомления',[2, 0], subscribe,       false, ['подписка','/subscribe'],   'subscribe');
menu.addButton('🔕 Отписаться от уведомлений',[2, 1], unsubscribe,     false, ['отписка','/unsubscribe'],   'unsubscribe');

menu.registerTriggers(bot);
const menuMiddleware = async (ctx, next) => {
  let handled = false;

  if (ctx.callbackQuery) {
    handled = await menu.triggerFromCallbackQuery?.(ctx);
  } else if (ctx.message) {
    handled = await menu.triggerFromMessage?.(ctx);
  }

  if (!handled) {
    await menu.drawMenu(ctx);
    return await next();
  }
};

// --- Обработка callback для ВИП ---
bot.on('callback_query', async (ctx, next) => {
  const data = ctx.callbackQuery?.data;
  if (data?.startsWith('vip_')) {
    return await handleVipSelection(ctx);
  }
  return next();
});

module.exports = { menuMiddleware };
