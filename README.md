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

У дистрибутиві знаходиться Django-проєкт під назвою commerce, в якому міститься один застосунок auctions.Спочатку відкрийте auctions/urls.py, де визначено URL-конфігурацію для цього застосунку.Зазирніть до auctions/views.py, щоб побачити види, пов’язані з кожним з цих маршрутів.Представлення login_view відображає форму входу в обліковий запис для користувача, що пробує отримати сторінку методом GET. Коли користувач надішле форму за допомогою запиту POST, його буде автентифіковано, відбудеться вхід в обліковий запис і користувача перенаправлять на головну сторінку. Представлення logout_view здійснює вихід користувача з облікового запису і перенаправляє його на сторінку. Насамкінець, маршрут register показує користувачу форму реєстрації та створює нового користувача після надання заповненої форми. Все це вже зроблено для вас, тож ви повинні мати змогу одразу запустити застосунок для створення користувачів.

Щоб розпочати роботу вебсеревера виконайте.

    python manage.py runserver

або

    python run.py

I зайдіть на сайт у своєму браузері на http://127.0.0.1:8000/.

Щоб запустити тести виконайте

    python manage.py test auctions/tests

