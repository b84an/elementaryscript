#!/bin/bash
#                               u,
#                               E[
#                        ._aawgmCmgwwa,,
#                     _amBQWmWmBCWmBmmWWmw,.
#                  .amWWmBBmWmWBCWmWBWmWmBWma,
#                 ammmmmWmWBBWmW[WmWmWmWmWmWWQa,
#               _mmmWmWWmWmWmBBW(BWmWmWmWmWmBmmmc
#              <WmBWmWmBBBBBWmWm(XBBBBBBBWmWmWBBma
#             <WmWmBBBWmWmWmWmWD.]BWmWmWmWmWmWmWBWL
#            =WBWmWmWmWmWmWmWmW[-:WmWmWmWmWmWmWmBmWL
#           .mWmBBBWmWmWmWmWmWZ-::]WmWmWmWmWmWmWBWmm;
#           jmBWmWmWmWmWmWmWmW':::.4WmWmWmWmWmWmBBBWm
#           mBWmWmWmWmWmWmWmW(_i_<=%SWmWmWmWmWmWmWmWm;
#          =WmBBBBBWmWmWmBBBC+++++++<WmWmWmBBBBBBBWmWL
#          ]mWBWmWmWmBBBBWmWC-::::::<WmWmWmWmWmWmWmWmk
#          ]BBBmWmWmWmWmWmW#6iiiiiii%#WmWmWmWmWmWmWmBE
#          ]mWmWmWmWmWmWmWmm;. . . . wWmWmWmWmWmWmWmWk
#          -WmWmWmWmWmWmWmB(....-..-.-9WmWmWmWmWmWmWmf
#           $WmWmWmWmWmWmP`...-._:...:."QmWmWmWmWmWmW'
#           ]WmWmWmWmWmB! ......m/......-$mWmWmWmWmWZ
#            $mWmWmWmW#^.......]Wh.......-4WmWmBBBBm'
#            +#WmWmWmW'... . . mmW/.. .... 4WmWmWmW[
#             )#WmWmW'.. . .. -""!~. .. . .-$mWmWmf
#              -WmBW[ . . . . ...   .  . . .-WmWm!
#               -4WZ  .  . . __. .__. . . .  ]BD^
#                 3' .  .    mE`  ?W[       . S`
#                 2 .       ]F  _. "C    .    ];
#                <[         -   ?'  -          L
#                ]            _s_s,.           3
#                """""""""""""" . """"""""""!""?
# Builder Creator Script
# Trasforma il tuo Linux in un AvoLinux
# By Ivan.bertotto@gmail.com
# Rilasciato sotto licenza GplV2
#
# file delle funzioni e delle variabili
#
isroot () {
  if [ "$EUID" -ne 0 ]
    then

    echo "Questo script va eseguito come root "
    exit 1
  else
    echo "Bene , sei root"
    ISROOT="YES"
  fi
}

isuser () {
  if (whoami != root)
    then
      echo "Non sei utente root"
      ISUSER="YES"
    else
      echo "Non puoi eseguire questo script da root"
      exit 1
  fi
}

issudo () {
  if sudo -vn 2> /dev/null; then
    echo "Bene, sei nei sudoers"
    ISSUDO="YES"
  else
    echo "Non hai i permessi necessari per eseguire questo script"
    exit 1
  fi
}

 isconnected () {
   wget -q --spider https://www.avoconnect.itisavogadro.org/

   if [ $? -eq 0 ]; then
       echo "Bene, siamo online"
       ISCONNECTED="YES"
   else
       echo "Sembra che non sei collegato a internet, correggi e riprova"
       exit 1
   fi
}

logga () {
DATAEVENTO=`date +"%Y-%m-%d %H:%M:%S"`
  echo -e "$DATAEVENTO  -- $1" >> $WORKINGFOLDER/log/install.log
  echo -e "$DATAEVENT   -- $1"
  # notify-send -i "/usr/AvoScript/img/avologo.png" -t 1300 "$1"
  zenity --info --text="$1" --timeout 2 --title="AvoScript" --width="300"


}

loggauser () {
DATAEVENTO=`date +"%Y-%m-%d %H:%M:%S"`
  echo -e "$DATAEVENTO  -- $1" >> $LOGUSERFILE
  echo -e "$DATAEVENT   -- $1"
  notify-send -i "/usr/AvoScript/img/avologo.png" -t 1300 "$1"

}

# funzioni di scrittura nei file di configurazione : non devo mettere il carattere = (uguale)

escape_su_sed() {
  sed -e 's/[]\/$*.^[]/\\&/g'
}

scrivi_cfg() { # path, key, value
  cancella_cfg "$1" "$2"
  echo "$2=$3" >> "$1"
}

leggi_cfg() { # path, key -> value
  test -f "$1" && grep "^$(echo "$2" | escape_su_sed)=" "$1" | sed "s/^$(echo "$2" | escape_su_sed)=//" | tail -1
}

cancella_cfg() { # path, key
  test -f "$1" && sed -i "/^$(echo $2 | escape_su_sed).*$/d" "$1"
}

esiste_cfg() { # path, key
  test -f "$1" && grep "^$(echo "$2" | escape_su_sed)=" "$1" > /dev/null
}


installa () {
  PACCHETTO=$1
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $PACCHETTO|grep "install ok installed")
  echo Checking for $PACCHETTO: $PKG_OK
  if [ "" = "$PKG_OK" ]; then
    sudo apt-get --yes install $PACCHETTO
    DATAEVENTO=`date +"%Y-%m-%d %H:%M:%S"`
    logga "**** $1 installato"
  else
    logga "$1 già installato"
  fi
}


installadeb () {

# passare nome pacchetto e url da scaricare 
    pacchetto="$1"
    esiste=$(which $pacchetto)
    urlpacchetto="$2"
    if [ -z "$esiste" ]
    then
          echo "+++ Installo $pacchetto +++"
            if test -f "pacchettodainstallare.deb"; then
                rm pacchettodainstallare.deb
            fi
        
        wget -O pacchettodainstallare.deb $urlpacchetto
        sudo apt install ./pacchettodainstallare.deb -y
        rm pacchettodainstallare.deb
    else
          echo "+++ $pacchetto lo ha già installato qualcuno scaricando $urlpacchetto +++"
    fi

}




# la funzione verifica guarda se una cosa è già stata fatta
# $1 è il comando e se $2 è "F" forzo l'esecuzione anche se gia fatto, se N è normale
# leggo dal file di log
verifica () {
LOGFILE="$WORKINGFOLDER/log/install.log"
DATAEVENTO=`date +"%Y-%m-%d %H:%M:%S"`
touch $LOGFILE
count=$(grep -o "$1" $LOGFILE | wc -l)
if [ $count != 0 ];then
  if [ $2 = "F" ]; then
    echo $DATAEVENTO -- ***$2*** $1 >>  $LOGFILE
    $1
  fi
  if [ $2 = "N" ]; then
    echo "Comando gia eseguito  ($count volte)"
  fi
else
   echo $DATAEVENTO -- $1 >>  $LOGFILE
   $1
fi
}

trovatesto () {
  # verifica se nel file di log c'è una occorrenza , se si pone la variabile "vai" a "S" , "N"
  LOGFILE="$WORKINGFOLDER/log/install.log"
  count=$(grep -o "$1" $LOGFILE | wc -l)
  if [ $count != 0 ];then
    export vai="N"
  else
    export vai="S"
  fi
}

cancella () {
  # verifica se nel file di log c'è una occorrenza , se si pone la variabile "vai" a "S" , "N"
  if [ -f "$1" ]; then
    rm $1
  fi
  if [ -d "$1" ]; then
    rm -rf $1
  fi

}

# funzione per mettere in autostart qualcosa a livello user
autostart () {  notify-send -i "/usr/AvoScript/img/avologo.png" -t 700 "$1"

  if [ -n "$3" ]; then


DIRH="/home/$1/"
	if [ -d "$DIRH" ]; then
		   	logga " creazione autostart per utente $1 e app $3 : utente esistente"
			DIRA="$DIRH.config/autostart/"
				if [ -d "$DIRA" ]; then
		   			logga " creazione autostart per utente $1 e app $3 : abbiamo autostart in $1"
				else 	mkdir $DIRA
					chown $1 $DIRA
					chgrp $1 $DIRA
				fi
		echo -e  "[Desktop Entry]\nName=$2\nComment=$2\nExec=$3\nType=Application\nTerminal=false\nHidden=false"> $DIRA$2.desktop
		chmod +x $DIRA$2.desktop
    chmod 744 $DIRA$2.desktop
		chown $1 $DIRA$2.desktop
		chgrp $1 $DIRA$2.desktop
		logga " creazione autostart per utente $1 e app $3 : creato $DIRA$2.desktop"
	else
		logga " creazione autostart per utente $1 e app $3 :  NON Creato $DIRA$2.desktop "

	fi
else
  logga " Devi lanciare la funzione per creare autostart con tre parametri : utente nome e percorso_applicazione "
fi

}


# funzione per creare link sul Desktop
# passo come parametri il nome , l'oggetto da linkare e icona


##### Da fare !
linkmenu () {
# crea un link a menu
# parametri Name Exec Icon Isolate (S-N) autostart (S-N)
if [ -z "$1" ]
then
      echo "uso : linkmenu Name Exec (Icon) (Isolate (S-N)) (autostart (S-N))"
      exit 0
fi
name=$1

if [ -z "$2" ]
then
      echo "uso : linkmenu Name Exec (Icon) (Isolate (S-N)) (autostart (S-N))"
      exit 0
fi
exec=$2

if [ -z "$3" ]
then

      icon="/usr/AvoScript/img/avologo.png"
else
      icon=$4
fi

if [ -z "$4" ]
then

      isolate="N"
else
      isolate=$4
fi

if [ -z "$5" ]
then

      autostart="N"
else
      autostart=$5
fi

# settato tutto
# creo il file
FILE="$name.desktop"
if test -f "$FILE"; then
    rm $FILE
fi

echo $FILE
logga "$FILE"
echo "[Desktop Entry]">$FILE
scrivi_cfg "$FILE" "Version" "`date +"%Y-%m-%d %H:%M:%S"`"
scrivi_cfg "$FILE" "Name" "$name"
scrivi_cfg "$FILE" "Comment" "$name by Avoscript"
scrivi_cfg "$FILE" "Exec" "$exec"
scrivi_cfg "$FILE" "Terminal" "False"
scrivi_cfg "$FILE" "Type" "Application"
scrivi_cfg "$FILE" "Icon" "$icon"
scrivi_cfg "$FILE" "Categories" "Avogadro"
scrivi_cfg "$FILE" "StartupNotify" "True"

chmod +x $FILE

}



scarica () {
 isconnected
 isroot

 if [ -d "$WORKINGFOLDER/bin/scripts" ]; then
   echo "OK"
 else
   mkdir $WORKINGFOLDER/bin/scripts
 fi

 rm -rf $WORKINGFOLDER/bin/scripts/$1
      mkdir $WORKINGFOLDER/bin/scripts/$1
      mkdir $WORKINGFOLDER/bin/scripts/$1/files
  for robe in label.txt man.sh post.sh pre.sh remove.sh run.sh version
    do
    wget -q -O $WORKINGFOLDER/bin/scripts/$1/$robe $SERVERPATH/apps/items/$1/$robe
    chmod +x $WORKINGFOLDER/bin/scripts/$1/$robe
  done

logga "Scaricato $1"

unset $1

}

creautente() {
# Se passo username e password lo fa altrimenti chiede
isroot
if [ -n "$2" ]; then
  utente=$1
  pw=$2
else
  ENTRY=$(zenity --password --username)

  utente=`echo $ENTRY | cut -d'|' -f1`
  pw=`echo $ENTRY | cut -d'|' -f2`
fi

getent passwd $utente > /dev/null 2&>1

if [ $? -eq 0 ]; then
    logga "Non posso creare $utente perchè esiste già"
else
    logga "Creo utente $utente"
    useradd -m -p $pw $utente
fi

}


createrminal() {
# Se passo username lo fa solo a quello, sennò tutti
isroot
if [ -n "$1" ]; then
  utente=$1
  getent passwd $utente > /dev/null 2&>1

  if [ $? -eq 0 ]; then
    SERVERPATH=$(leggi_cfg "$WORKINGFOLDER/etc/AvoScript.conf" "SERVERPATH")
      wget -O listats.txt $SERVERPATH/apps/items/Amministrativa/files/listaterminal.txt
      wget -O default.remmina $SERVERPATH/apps/items/Amministrativa/files/ts.remmina

      cat listats.txt | while read terminalutente
        do
        logga "$terminalutente per $utente"
        nomets=$(echo $terminalutente |sed s/[.]/-/g)
        nomets="Terminal_$nomets"
        nomets="$nomets.remmina"
        cp default.remmina $nomets
        ipsource=$(hostname -I)
        scrivi_cfg $nomets server $terminalutente
        scrivi_cfg $nomets username $utente
        scrivi_cfg $nomets group Amministrativa
        scrivi_cfg $nomets clientname $ipsource


        if [ -f "/home/$utente/Desktop/$nomets" ]; then
            rm /home/$utente/Desktop/$nomets
        fi

          if [[ -f "/home/$utente/Desktop/$nomets" ]]; then
            rm /home/$utente/Desktop/$nomets
          fi
        mv $nomets /home/$utente/Desktop/.
        chmod $utente /home/$utente/Desktop/$nomets
        chgrp $utente /home/$utente/Desktop/$nomets
        chmod +x /home/$utente/Desktop/$nomets

        if [[ -f "/home/$utente/.local/share/remmina/$nomets" ]]; then
          rm /home/$utente/.local/share/remmina/$nomets
        fi

        cp /home/$utente/Desktop/$nomets /home/$utente/.local/share/remmina/.

        done
    rm listats.txt
    rm ts.remmina

  else
      logga "utente $utente non esiste, non posso continuare"
  fi

fi

}
