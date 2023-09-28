#!/bin/bash

# Überprüfen, ob der Benutzer Root-Rechte hat
if [ "$EUID" -ne 0 ]; then
    echo "Dieses Skript muss mit Root-Rechten ausgeführt werden."
    exit 1
fi

# Überprüfen, ob dialog installiert ist
if ! command -v dialog &> /dev/null; then
    echo "Dialog ist nicht installiert. Installiere es jetzt..."
    sudo apt install dialog
fi

# Funktion, die das Hauptmenü anzeigt
show_menu() {
    while true; do
        choice=$(dialog --menu "Hauptmenü" 10 40 4 1 "Check for Updates" 2 "Update System" 3 "Info" 4 "Erstelle Desktop-Verknüpfung" 5 "Beenden" 3>&1 1>&2 2>&3)
        case $choice in
            1) check_updates ;;
            2) update_system ;;
            3) show_info ;;
            4) create_desktop_shortcut ;;
            5) exit ;;
            *) echo "Ungültige Auswahl" ;;
        esac
    done
}

# Funktion, die nach Updates sucht
check_updates() {
    clear
    echo -e "\e[1;34mChecking for updates...\e[0m"
    sudo apt-get update
    echo -e "\e[1;32mUpdates wurden überprüft!\e[0m"
    read -p "Drücke Enter, um zum Hauptmenü zurückzukehren." dummy
}

# Funktion, die das System aktualisiert
update_system() {
    clear
    echo -e "\e[1;34mUpdating system...\e[0m"
    sudo apt-get upgrade
    echo -e "\e[1;32mSystem wurde aktualisiert!\e[0m"
    read -p "Drücke Enter, um zum Hauptmenü zurückzukehren." dummy
}

# Funktion, die Informationen anzeigt
show_info() {
    dialog --msgbox "Dies ist eine Beispiel-Anwendung.\n\nOptionen:\n1) Check for Updates: Sucht nach verfügbaren Updates.\n2) Update System: Führt ein Systemupdate durch.\n3) Info: Zeigt diese Nachricht an.\n4) Beenden: Beendet die Anwendung." 10 40
}

# Funktion, die eine Desktop-Verknüpfung erstellt
create_desktop_shortcut() {
    local DESKTOP_DIR="$HOME/Schreibtisch/"
    local SHORTCUT_NAME="Updater.desktop"

    echo -e "[Desktop Entry]\nVersion=1.0\nType=Application\nTerminal=true\nExec=$PWD/updater.sh\nName=Updater\nComment=Ein nützliches Tool\nIcon=$PWD/icon.png" > "$SHORTCUT_NAME"
    chmod +x "$SHORTCUT_NAME"

    if [ -d "$DESKTOP_DIR" ]; then
        cp "$SHORTCUT_NAME" "$DESKTOP_DIR"
        echo -e "\e[1;32mDesktop-Verknüpfung wurde erstellt!\e[0m"
    else
        echo -e "\e[1;31mFehler: Das Desktop-Verzeichnis wurde nicht gefunden.\e[0m"
    fi

    read -p "Drücke Enter, um zum Hauptmenü zurückzukehren." dummy
}



# Hauptprogramm
while true; do
    show_menu
done

