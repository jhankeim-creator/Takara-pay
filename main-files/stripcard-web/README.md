<<<<<<<< Update Guide >>>>>>>>>>>

Clone Version: 4.6.0
Immediate Older Version: 4.6.0
Current Version: 4.7.0

Feature Update:
1. Update htaccess Files For Enhance Site Security
2. Use config Instead Of Using env helper
3. Added Sitemap Generate Feature On Admin Panel  
4. Added File Permission Monitor And Restore Option On Admin Panel
5. Added Storage Relink/Repair Option On Admin Panel
6. 2FA Improvement Admin & User Panel
7. Updated Strowallet Virtual Card System
8. Updated Sudo Africa Virtual Card System
9. Updated Fileholder CDN
10. New Mail Provider (Reachead) Added
-----------------------------------------------------------------

Command For Fresh Install: 
1. composer update --no-dev
2. php artisan migrate:fresh --seed
3. php artisan passport:keys --force
4. php artisan passport:client --personal --no-interaction --provider=users
5. php artisan storage:link

Command For Update From 4.6.0 To 4.7.0:
1. composer update --no-dev
2. php artisan migrate
3. php artisan db:seed --class=Database\\Seeders\\Update\\VersionUpdateSeeder
