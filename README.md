# debian-casaos
minimal niceties for casaos on a fresh minimal debian

# don't wanna use wget
sudo apt update
sudo apt install curl -y

# one sudo to rule them all
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/itsjesseyo/debian-casaos/refs/heads/main/setup.sh)"
