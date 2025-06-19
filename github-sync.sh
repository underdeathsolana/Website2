#!/bin/bash

# Script name: github-sync.sh
# Description: Memudahkan sinkronisasi project ke GitHub dari Termux
# Author: Your Name
# Version: 1.0

# Warna untuk output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fungsi untuk mengecek apakah perintah ada
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Fungsi untuk inisialisasi repo Git
init_git_repo() {
  echo -e "${YELLOW}Menginisialisasi repositori Git...${NC}"
  git init
  git add .
  git commit -m "Initial commit"
  echo -e "${GREEN}Repositori Git berhasil diinisialisasi!${NC}"
}

# Fungsi untuk menghubungkan ke GitHub
connect_to_github() {
  echo -e "${BLUE}Masukkan URL repositori GitHub Anda (https://github.com/underdeathsolana/Website2.git):${NC}"
  read repo_url
  
  echo -e "${YELLOW}Menghubungkan ke repositori GitHub...${NC}"
  git remote add origin "$repo_url"
  git branch -M main
  git push -u origin main
  echo -e "${GREEN}Berhasil terhubung ke GitHub!${NC}"
}

# Fungsi untuk sinkronisasi perubahan
sync_changes() {
  echo -e "${BLUE}Masukkan pesan commit:${NC}"
  read commit_message
  
  echo -e "${YELLOW}Memproses perubahan...${NC}"
  git add .
  git commit -m "$commit_message"
  git pull --rebase origin main
  git push origin main
  echo -e "${GREEN}Perubahan berhasil disinkronisasi ke GitHub!${NC}"
}

# Main script
clear
echo -e "${GREEN}=== GitHub Sync Tool untuk Termux ===${NC}"
echo -e "Script ini akan membantu sinkronisasi project ke GitHub\n"

# Cek apakah git sudah terinstall
if ! command_exists git; then
  echo -e "${RED}Git tidak ditemukan. Menginstall Git...${NC}"
  pkg install git -y
fi

# Cek apakah di direktori ini sudah ada repo Git
if [ -d ".git" ]; then
  echo -e "${YELLOW}Repositori Git sudah ada di direktori ini.${NC}"
  PS3='Pilih aksi: '
  options=("Sinkronkan Perubahan" "Ubah Remote URL" "Keluar")
  select opt in "${options[@]}"
  do
    case $opt in
      "Sinkronkan Perubahan")
        sync_changes
        break
        ;;
      "Ubah Remote URL")
        echo -e "${BLUE}Masukkan URL remote GitHub yang baru:${NC}"
        read new_url
        git remote set-url origin "$new_url"
        echo -e "${GREEN}Remote URL berhasil diubah!${NC}"
        break
        ;;
      "Keluar")
        echo -e "${YELLOW}Keluar dari script.${NC}"
        exit 0
        ;;
      *) echo -e "${RED}Pilihan tidak valid${NC}";;
    esac
  done
else
  echo -e "${YELLOW}Direktori ini belum menjadi repositori Git.${NC}"
  read -p "Apakah Anda ingin menginisialisasi repositori Git baru? (y/n) " yn
  case $yn in
    [Yy]* )
      init_git_repo
      read -p "Apakah Anda ingin menghubungkan ke GitHub? (y/n) " gh_yn
      case $gh_yn in
        [Yy]* )
          connect_to_github
          ;;
        [Nn]* )
          echo -e "${YELLOW}Anda bisa menghubungkan ke GitHub nanti dengan menjalankan script ini kembali.${NC}"
          exit 0
          ;;
        * )
          echo -e "${RED}Silakan jawab y atau n.${NC}"
          ;;
      esac
      ;;
    [Nn]* )
      echo -e "${YELLOW}Keluar dari script.${NC}"
      exit 0
      ;;
    * )
      echo -e "${RED}Silakan jawab y atau n.${NC}"
      ;;
  esac
fi

echo -e "\n${GREEN}Proses selesai!${NC}"
