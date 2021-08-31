#sudo su


# FUNZIONI

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

installadarepo () {

# passare nome pacchetto da installare  
    if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ];
    then
        echo "+++ Installo $1 +++"
        apt-get install $1 -y;
    else
        echo "+++ $1 lo ha già installato qualcuno +++"
    
    fi

}

#apt update
#apt upgrade



installadeb google-chrome https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
installadeb pinguybuilder https://sourceforge.net/projects/pinguy-os/files/ISO_Builder/pinguybuilder_5.2-1_all.deb
installadeb ferdi https://github.com/getferdi/ferdi/releases/download/v5.6.0/ferdi_5.6.0_amd64.deb
installadeb anydesk https://download.anydesk.com/linux/anydesk_6.1.0-1_amd64.deb
installadeb atom https://atom.io/download/deb


for pacchetto in gdebi remmina nextcloud-desktop vlc gimp libreoffice synaptic filezilla firefox rdesktop
do
   installadarepo $pacchetto
done
apt clean
