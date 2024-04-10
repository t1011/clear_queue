#!/usr/bin/perl

use strict;
use warnings;

my $domain = shift;

# Проверка корректности ввода
if (!$domain) {
  print "Необходимо указать домен или часть домена!\n";
  exit 1;
}

# Подключение к очереди Postfix
my $postfix_queue = "/var/spool/postfix/maildrop";

# Получение списка сообщений в очереди
opendir(my $dh, $postfix_queue) or die "Невозможно открыть очередь Postfix: $!";

my @messages = grep { /\.qmail$/ } readdir($dh);

closedir($dh);

# Обработка сообщений
foreach my $message (@messages) {
  my ($name, $script) = split /\./, $message;
  my $email = "$name@$domain";

  # Проверка email на соответствие
  if ($email =~ /$domain/) {
    print "Удаление сообщения $message для $email...\n";
    unlink "$postfix_queue/$message";
  }
}

print "Очистка очереди Postfix для $domain завершена.\n";
