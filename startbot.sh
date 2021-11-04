#!/bin/bash
#set -x
PWD=$(pwd)
#<<<----color code substitution---->>>#
S0="\033[30m" B0="\033[40m"
S1="\033[31m" B1="\033[41m"
S2="\033[32m" B2="\033[42m"
S3="\033[33m" B3="\033[43m"
S4="\033[34m" B4="\033[44m"
S5="\033[35m" B5="\033[45m"
S6="\033[36m" B6="\033[46m"
S7="\033[37m" B7="\033[47m"
R0="\033[00m" R1="\033[0;00m"

#<<<===configuration===>>>
exit_on_signal_SIGINT () {
rm -rf ${PWD}/bhutuu.py
}
exit_on_signal_SIGINT SIGINT
function resetbot() {
if [[ -f "$HOME/.tgbotpy-config" ]]; then
new="new"
else
new=""
fi
printf "${S2}Set your $new BOT TOKEN: ${R0}"
read newTOKEN
cat <<- CONF > ${HOME}/.tgbotpy-config
${newTOKEN}
CONF
echo
if [[ $? == 0 ]]; then
printf "${S2}[${S4}✔️${S2}]${S6}New configuration successfull${R0}\n"
else
printf "${S2}[${S1}❌${S2}]${S1}New configuration failed! Try again!!${R0}\n"
fi
}
function startbot() {
if [[ ! -f $HOME/.tgbotpy-config ]]; then
printf "${S2}[${S1}!${S2}]${S1} please configure your bot and chat_id!${R0}\n"
resetbot
else
:
fi
TOKEN=$(cat $HOME/.tgbotpy-config)
DELCMD="${PWD}/fetch"
std="${PWD}/assets/status.sh"
cat <<- CONF > $PWD/bhutuu.py
#!/usr/bin/env python
import logging, os
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
def filter():
    os.system('bash ${PWD}/assets/status.sh')

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=logging.INFO)
logger = logging.getLogger(__name__)

def start(update, context):
    """Send a message when the command /start is issued."""
    update.message.reply_text('''
    Hi! Its bhutuu_bot here made by Suman Kumar in python
    I am still in developing stage :)''')
def help(update, context):
    """Send a message when the command /help is issued."""
    update.message.reply_text('''
    Help menue
     ===============================
     cmd         usage
     /help :-> to show this
                  help message
     /start :-> to start me
     /say   :-> only for BHUTUU
     /fetch :-> To show system info.
     ===============================
                              ''')
def fetch(update, context):
    """Send the sys information."""
    filter()
    pwdfile = open("${PWD}/fetch", "r")
    for passd in pwdfile:
        update.message.reply_text((passd))
    os.system('rm -rf ${PWD}/fetch')
def say(update, context):
    """send a messagw when the command /say is issued."""
    update.message.reply_text('I love you 😔')
def echo(update, context):
    """Echo the user message."""
    update.message.reply_text(update.message.text)
def error(update, context):
    """Log Errors caused by Updates."""
    logger.warning('Update "%s" caused error "%s"', update, context.error)
def dele(update, context):
    """Delete the the message to which it is replied."""
    update.message.reply_text('/del')
def main():
    """Start the bot."""
    updater = Updater("${TOKEN}", use_context=True)
    dp = updater.dispatcher
    dp.add_handler(CommandHandler("start", start))
    dp.add_handler(CommandHandler("help", help))
    dp.add_handler(CommandHandler("say", say))
    dp.add_handler(CommandHandler("fetch", fetch))
    dp.add_handler(CommandHandler("del", dele))
    dp.add_error_handler(error)
    updater.start_polling()
    updater.idle()
if __name__ == '__main__':
    main()
CONF
python bhutuu.py
}
function HELP() {
echo -e "
${S2}=====================${R0}
     ${B1}HELP MENUE${R1}
${S2}_____________________${R0}

 ${S2} command                    usage${R0}
 ${S1} =======                    =====${R0}

 ${S4} reset bot${S3}      |-»${S7}   To clear the credential of
                       previous and set new one.${R0}
 ${S4} help${S3}           |-»${S7}   To show this help menue.${R0}

 ${S4} start${S3}          |-»${S7}   To start for sending msges
                       with given bot and chatid${R0}
 ${S4} exit${S3}           |-»${S7}   To EXIT!!${R0}
"
}
function main() {
printf "${S2}Tip${S1}:${S2}: execute '${S4}help${S2}' or '${S4}?${S2}' for help menue\n"
while true; do
printf "\033[4;36mBhutuu-bot\033[0;00m \033[1;37m> \033[0;00m"
read stdinput
if [[ ${stdinput,,} == 'help' || ${stdinput} == '?' ]]; then
HELP
elif [[ ${stdinput,,} == 'reset bot' ]]; then
resetbot
elif [[ ${stdinput,,} == 'start' ]]; then
startbot
#elif [[ ${stdinput,,} == 'banner' ]]; then
#banner
elif [[ ${stdinput,,} == 'exit' ]]; then
rm -rf ${PWD}/bhutuu.py
exit 0
else
printf "${S2}[${S1}!${S2}] ${S7}invalid parameter ‘${S4}${stdinput}${S7}’ ${S1}:: ${S7}Execute ‘${S3}help${S7}’ for help menue!!${R0}\n"
fi
done
}
main
