# TAKARA PAY

Platfòm **kat kredi vityèl** (baz StripCard v4.7): backend Laravel, frontend Next.js, app Flutter — mak **TAKARA PAY**.

## Estrikti repo

```
main-files/
├── stripcard-web/              # Laravel — admin + API
├── stripcard-app/
│   ├── StripCard_User_App_v4.7.0/
│   └── StripCard_User_App_Update_v4.6.0_to_v4.7.0/
├── app/, public/, package.json # Next.js 16
└── stripcard-documentation.html
```

Non dosye teknik (`stripcard-*`) rete pou konpatibilite kòd; non itilizatè a se **TAKARA PAY** (gade [BRANDING.md](./BRANDING.md)).

## Enstalasyon rapid (Laravel)

```bash
cd main-files/stripcard-web
cp .env.example .env
composer install --no-dev   # si bezwen
php artisan migrate:fresh --seed
php artisan key:generate
php artisan passport:keys --force
php artisan passport:client --personal --no-interaction --provider=users
php artisan storage:link
```

Frontend Next: `cd main-files && npm install && npm run dev`

Flutter: `cd main-files/stripcard-app/StripCard_User_App_v4.7.0 && flutter pub get`

Docs vandè: [stripcard.app/documentation](https://stripcard.app/documentation/welcome)

Odit repo: [REPO_AUDIT.md](./REPO_AUDIT.md)
