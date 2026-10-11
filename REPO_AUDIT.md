# TAKARA PAY — Odit repo

Dat: 2026-10-11 (UTC)

## Rezime

- Kontni zip CodeCanyon dekonprese nan `main-files/`.
- Kle Passport OAuth, fichye `.rnd`, ak `APP_KEY` reyèl retire nan working tree ak **istwa Git** (`git filter-repo`).
- `.env` pa swiv nan Git; itilize `.env.example`.

## Konpare ak zip orijinal

| Metrik | Valè |
|--------|------|
| Fichye nan zip (ekstrè, san zip anndan / san sekre) | 17 437 |
| Fichye nan repo `main-files/` | 17 437 |
| Manke nan repo | 0 |
| Extra nan repo | 0 |
| Gwosè `main-files/` (working tree) | ~284 Mo |
| Fichye swiv Git sou `main-files/` | 17 437 |

## Estrikti prensipal

| Pati | Chemen |
|------|--------|
| Laravel API/Admin | `main-files/stripcard-web/` |
| Next.js frontend | `main-files/app/`, `main-files/package.json` |
| Flutter app | `main-files/stripcard-app/StripCard_User_App_v4.7.0/` |
| Patch web 4.6→4.7 | `main-files/stripcard-web/update-v4.6-to-v4.7/` |
| Patch app 4.6→4.7 | `main-files/stripcard-app/StripCard_User_App_Update_v4.6.0_to_v4.7.0/` |

## Sekre / sertifikat (swivi Git)

| Atik | Nan repo? |
|------|-----------|
| `main-files/stripcard-web/storage/oauth-private.key` | Non |
| `main-files/stripcard-web/storage/oauth-public.key` | Non |
| `main-files/stripcard-web/.env` | Non |
| `main-files/stripcard-web/.rnd` | Non |
| `APP_KEY=base64:...` nan `.env.example` | Non (placeholder vid) |

## Nòt enpòtan

- **Seeders** Laravel (`PaymentGatewaySeeder`, elatriye) gen **kle demo sandbox** vandè — sa fè pati pwodwi zip la; ranplase anvan prodiksyon.
- **`vendor/`** ka gen fichye `.pem` CA (lib PHP) — pa kle pèsonèl aplikasyon ou.

## Apre clone

```bash
cd main-files/stripcard-web
cp .env.example .env
php artisan key:generate
php artisan passport:keys --force
php artisan passport:client --personal --no-interaction --provider=users
```

Frontend Next: `cd main-files && npm install && npm run dev`

Flutter: `cd main-files/stripcard-app/StripCard_User_App_v4.7.0 && flutter pub get`

Docs: https://stripcard.app/documentation/welcome
