package net.appdevs.stripcard

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity

// local_auth requires the host Activity to be a FragmentActivity; with the
// default FlutterActivity the biometric prompt throws `no_fragment_activity`
// and never appears. FlutterFragmentActivity is the supported base class.
class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Card numbers, CVVs, and the 2FA setup secret render on screen
        // somewhere in this app — block screenshots/screen recording and
        // hide app content from the recent-apps task-switcher thumbnail.
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
    }
}
