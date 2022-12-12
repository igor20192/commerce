# Commerce #

Онлайн-майданчик для електронної торгівлі та проведення аукціонів, на якому користувачі зможуть виставляти товари, розміщувати ставки та додавати товари до списку відстеження.

## Перші кроки ##

Завантажте дистрибутив

    git clone git@github.com:igor20192/commerce.git

або 

    git clone https://github.com/igor20192/commerce.git

У вашому терміналі Linux виконайте

    cd commerce

Створіть віртуальне оточення python

    python3 -m venv <назва оточення>

Активуйте оточення

    . <назва оточення>/bin/activate

Встановити всі залежності

    pip install -r requirements.txt

Виконайте python manage.py makemigrations auctions щоб створити міграції для застосунку auctions.

    python manage.py makemigrations

Виконайте  міграції до вашої бази даних.

    python manage.py migrate

## Пояснення ##

У дистрибутиві знаходиться Django-проєкт під назвою commerce, в якому міститься один застосунок auctions.Спочатку відкрийте auctions/urls.py, де визначено URL-конфігурацію для цього застосунку.

       