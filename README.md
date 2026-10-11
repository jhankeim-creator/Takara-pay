# Takara-pay

Depo pou solisyon **StripCard** (kat kredi vityèl) — achiv CodeCanyon dekonprese lokalman nan `main-files/` (pa nan Git; twò gwo).

## Estrikti apre dekonpresyon

```
/workspace/
├── codecanyon-...-stripcard-virtual-credit-card-solution.zip   # orijinal (Git LFS)
└── main-files/
    ├── stripcard-documentation.html   → redireksyon docs: https://stripcard.app/documentation/welcome
    │
    ├── stripcard-web/                 # Backend Laravel v4.7.0 (admin + API pou app)
    │   ├── app/, routes/, database/, ...
    │   ├── .env.example               # modèl konfigirasyon
    │   ├── stripcard-web-new-v4.7.0.zip              # (deja ekstrè)
    │   └── update-v4.6-to-v4.7/     # patch soti v4.6 → v4.7
    │
    ├── stripcard-app/
    │   ├── StripCard_User_App_v4.7.0/           # App Flutter konplè (v4.8.0+19 nan pubspec)
    │   └── StripCard_User_App_Update_v4.6.0_to_v4.7.0/   # fichye delta pou mete ajou
    │
    └── (Next.js frontend)           # Fichye rasin `main-files/` soti nan stripcard-next-template.zip
        ├── app/, public/, package.json
        └── Next 16 + React 19 (Cloudflare / open-next)
```

## Kote kòmanse

| Pati | Chemen | Teknoloji |
|------|--------|-----------|
| API & admin | `main-files/stripcard-web/` | Laravel, Passport, MySQL |
| Sit itilizatè | `main-files/` (Next template) | Next.js 16 |
| Mobil | `main-files/stripcard-app/StripCard_User_App_v4.7.0/` | Flutter / GetX |

Enstalasyon fre (Laravel): gade `main-files/stripcard-web/README.md` (`composer update`, `migrate:fresh --seed`, Passport, `storage:link`).

## Git LFS

Si zip la pa telechaje, nan repo a:

```bash
git lfs pull
unzip -o codecanyon-WfuymO5v-stripcard-virtual-credit-card-solution.zip -d .
cd main-files && unzip -o stripcard-next-template.zip
cd stripcard-web && unzip -o stripcard-web-new-v4.7.0.zip
```
