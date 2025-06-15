# AdSiS-WindowsOnLinuxHost

Konfiguracja środowiska QEMU do uruchamiania Windows Server na systemie Linux. Projekt przeznaczony do zajęć "Administracja sieciowymi systemami operacyjnymi".

## Spis treści

- [Opis projektu](#opis-projektu)
- [Wymagania](#wymagania)
- [Instalacja](#instalacja)
- [Konfiguracja środowiska](#konfiguracja-środowiska)
- [Uruchamianie maszyn wirtualnych](#uruchamianie-maszyn-wirtualnych)
- [Współdzielenie plików](#współdzielenie-plików)
- [Struktura katalogów](#struktura-katalogów)
- [Licencja](#licencja)

## Opis projektu

Repozytorium zawiera skrypty oraz instrukcje do uruchomienia kilku maszyn wirtualnych z Windows Server 2019 przy użyciu QEMU/KVM na Linuksie. Dodatkowo udostępniony jest prosty serwer WWW do wymiany plików pomiędzy systemami Linux i Windows.

## Wymagania

- Linux z obsługą KVM/QEMU
- Python 3.x
- `pip` (Python package manager)
- `bridge-utils`, `iptables`
- Obraz ISO Windows Server 2019 (do pobrania: [Microsoft Eval Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019))
- Obraz sterowników VirtIO ([virtio-win.iso](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso))

## Instalacja

1. **Klonowanie repozytorium**
   ```sh
   git clone <adres_repozytorium>
   cd AdSiS-WindowsOnLinuxHost
   ```

2. **Konfiguracja środowiska Python**
   ```sh
   bash setup_python.sh
   ```

3. **Instalacja narzędzi sieciowych i przygotowanie obrazów dysków**
   ```sh
   bash setup_windows_server.sh
   ```

## Konfiguracja środowiska

Skrypt `setup_windows_server.sh`:
- Tworzy mostek sieciowy `br0`
- Ustawia adresację IP i reguły NAT
- Pobiera sterowniki VirtIO
- Tworzy obrazy dysków dla maszyn wirtualnych

**Uwaga:** Skrypt wymaga uprawnień administratora (sudo).

## Uruchamianie maszyn wirtualnych

Do uruchamiania poszczególnych maszyn służą skrypty:
- `start_dc1.sh` – kontroler domeny (uruchomić jako pierwszy)
- `start_svr1.sh`, `start_svr2.sh`, `start_svr3.sh` – serwery
- `start_cl1.sh`, `start_cl2.sh` – stacje robocze

Przykład uruchomienia:
```sh
bash start_dc1.sh
bash start_svr1.sh
bash start_cl1.sh
```

## Współdzielenie plików

Do wymiany plików między systemami Linux i Windows służy prosty serwer WWW oparty na Flasku.

### Uruchomienie serwera plików

```sh
python3 file_exchange_server.py
```

Serwer będzie dostępny pod adresem: [http://localhost:5000](http://localhost:5000)

- Przeglądaj i pobieraj pliki z katalogu `uploads/`
- Przesyłaj nowe pliki przez formularz na stronie

## Tworzenie nowych komputerów wirtualnych

Aby dodać nową maszynę wirtualną (np. kolejny serwer lub stację roboczą), wykonaj poniższe kroki:

1. **Sklonuj istniejący skrypt uruchamiający**  
   Skopiuj jeden z plików `start_*.sh` i nadaj mu nową nazwę, np. `start_cl3.sh` dla trzeciej stacji roboczej:
   ```sh
   cp start_cl1.sh start_cl3.sh
   ```

2. **Zmień nazwę maszyny w skrypcie**  
   Otwórz nowy plik (np. `start_cl3.sh`) i zmień nazwę maszyny (`-name`), aby była unikalna:
   ```sh
   # ...istniejący kod...
   -name cl3 \
   # ...istniejący kod...
   ```

3. **Zmień adres MAC**  
   Każda maszyna musi mieć unikalny adres MAC. Znajdź linię z opcją `-net nic,macaddr=...` i zmień adres MAC (np. ostatni oktet):
   ```sh
   # ...istniejący kod...
   -net nic,macaddr=52:54:00:12:34:03 \
   # ...istniejący kod...
   ```
   **Uwaga:** Adres MAC powinien być unikalny w sieci wirtualnej.

4. **Utwórz nowy obraz dysku**  
   Utwórz nowy plik dysku dla maszyny, np.:
   ```sh
   qemu-img create -f qcow2 cl3.qcow2 40G
   ```
   i zaktualizuj ścieżkę do dysku w skrypcie:
   ```sh
   # ...istniejący kod...
   -drive file=cl3.qcow2,if=virtio,cache=writeback \
   # ...istniejący kod...
   ```

5. **Dostosuj inne ustawienia**  
   W razie potrzeby zmień ilość RAM, liczbę CPU lub inne parametry.

6. **Uruchom nową maszynę**  
   ```sh
   bash start_cl3.sh
   ```

**Podsumowanie:**  
- Każda maszyna musi mieć unikalną nazwę, adres MAC i plik dysku.
- Skrypty uruchamiające można dowolnie kopiować i modyfikować według powyższych wskazówek.

## Struktura katalogów

```
file_exchange_server.py      # Serwer wymiany plików (Flask)
setup_python.sh              # Skrypt konfiguracji środowiska Python
setup_windows_server.sh      # Skrypt konfiguracji środowiska QEMU/KVM
start_*.sh                   # Skrypty uruchamiające maszyny wirtualne
requirements.txt             # Wymagane pakiety Pythona
templates/index.html         # Szablon strony WWW serwera plików
uploads/                     # Katalog współdzielonych plików
```

## Licencja

Projekt udostępniony na licencji MIT. Szczegóły w pliku [LICENSE](LICENSE).

