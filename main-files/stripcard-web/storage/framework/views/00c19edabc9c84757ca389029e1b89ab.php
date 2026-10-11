<?php if($basic_settings->push_notification_config != null && $basic_settings->push_notification_config->method == 'pusher'): ?>
    <script src="https://js.pusher.com/beams/1.0/push-notifications-cdn.js"></script>
    <script>
        var clientInstanceId = "<?php echo e($basic_settings->push_notification_config->instance_id); ?>";
        const beamsClient = new PusherPushNotifications.Client({
            instanceId: clientInstanceId,
        });

        // navigator.serviceWorker.register('<?php echo e(asset('service-worker.js')); ?>')
        //     .then((registration) => {
        //     messaging.useServiceWorker(registration)});

        var generatePublisherId = "<?php echo e(make_user_id_for_pusher('user', auth()->user()->id)); ?>";
        const beamsTokenProvider = new PusherPushNotifications.TokenProvider({
            url: "<?php echo e(setRoute('user.pusher.beams.auth')); ?>",
        });

        beamsClient
            .start()
            .then((beamsClient) => beamsClient.getDeviceId())
            .then((response) => beamsClient.setUserId(generatePublisherId, beamsTokenProvider))
            .catch(console.error());
    </script>
<?php endif; ?>

<?php if($basic_settings->broadcast_config != null && $basic_settings->broadcast_config->method == 'pusher'): ?>
    <script src="https://js.pusher.com/7.2/pusher.min.js"></script>
    <script>
        // Enable pusher logging - don't include this in production
        // Pusher.logToConsole = true;

        var primaryKey = "<?php echo e($basic_settings->broadcast_config->primary_key ?? ''); ?>";
        var cluster = "<?php echo e($basic_settings->broadcast_config->cluster ?? ''); ?>";

        var pusher = new Pusher(primaryKey, {
            cluster: cluster,
        });

        var channel = pusher.subscribe('user');
        channel.bind('dashbord-push', function(data) {
            var jsonData = JSON.stringify(data);
            var object = JSON.parse(jsonData);
            document.querySelector(".header-notification-area .bling-area").classList.remove("d-none");
            document.querySelector(".notifications-clear-all-btn").classList.remove("d-none");
            var message = `
            <li>
                <div class="thumb">
                    <img src="${object.message.image}" alt="user">
                </div>
                <div class="content">
                    <h6 class="title">${object.message.title}</h6>
                    <span class="sub-title">${object.message.time}</span>
                </div>
            </li>
        `;
            if (document.querySelector(".notification-list .not-found") != null) {
                document.querySelector(".notification-list .not-found").remove();
            }
            document.querySelector(".notification-wrapper .notification-list").innerHTML += message;
        });
    </script>
<?php endif; ?>

<script></script>
<?php /**PATH /Users/mehedihasan/laravel/projects/strip-card/v4.7.0/full_project/resources/views/user/partials/push-notification.blade.php ENDPATH**/ ?>