# Takara-pay

Solisyon **StripCard v4.7** (kat kredi vityèl): backend Laravel, frontend Next.js, app Flutter.

## Estrikti repo

```
main-files/
├── stripcard-web/              # Laravel 4.7 — admin + API
├── stripcard-app/
│   ├── StripCard_User_App_v4.7.0/
│   └── StripCard_User_App_Update_v4.6.0_to_v4.7.0/
├── app/, public/, package.json # Next.js 16 (template itilizatè)
└── stripcard-documentation.html
```

## Enstalasyon rapid (Laravel)

```bash
cd main-files/stripcard-web
cp .env.example .env   # oswa konfigire .env (pa commit)
composer install --no-dev   # si bezwen
php artisan migrate:fresh --seed
php artisan key:generate
php artisan passport:keys --force
php artisan passport:client --personal --no-interaction --provider=users
php artisan storage:link
```

Frontend Next: `cd main-files && npm install && npm run dev`

Flutter: `cd main-files/stripcard-app/StripCard_User_App_v4.7.0 && flutter pub get`

Docs: [stripcard.app/documentation](https://stripcard.app/documentation/welcome)
