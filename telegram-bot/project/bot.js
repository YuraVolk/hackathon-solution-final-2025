const { Telegraf } = require('telegraf');
const bot = new Telegraf('7881047853:AAGkhghEj3kcGVxsRKSZLsPfLgt1paXw54E');
module.exports = { bot };

const { authMiddleware } = require('./middleware/auth');
const { menuMiddleware } = require('./middleware/main');

bot.use(authMiddleware);
bot.use(menuMiddleware);
bot.launch();

process.once('SIGINT', () => bot.stop('SIGINT'));
process.once('SIGTERM', () => bot.stop('SIGTERM'));