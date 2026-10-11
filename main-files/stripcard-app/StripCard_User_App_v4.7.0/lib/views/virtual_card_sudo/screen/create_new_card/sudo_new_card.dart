import "package:stripcard/views/virtual_card_sudo/controller/create_card/sudo_create_card_controller.dart";
import "package:stripcard/base/utils/language/language_controller.dart";
import "package:stripcard/base/themes/app_colors.dart";
import "package:stripcard/base/themes/app_text_styles.dart";
import "package:stripcard/base/utils/basic_screen_import.dart";
import "package:stripcard/base/widgets/design_system/sc_button.dart";
import "package:stripcard/base/widgets/inputs/sudo_new_card_widget.dart";

class SudoCreateNewScreen extends StatelessWidget {
  SudoCreateNewScreen({super.key});

  final controller = Get.put(SudoCreateCardController());

  // Single instance so the pinned footer can call its preserved submit logic.
  final _form = SudoCreateCardWidget(buttonText: Strings.proceed);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? AppColorsDark.bg : AppColors.bg;
    final text = dark ? AppColorsDark.text : AppColors.text;
    final lang = Get.find<LanguageController>();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bg,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: text),
          onPressed: Get.back,
        ),
        title: Text(
          lang.getTranslation(Strings.createANewCard),
          style: AppTextStyles.bodyMed.copyWith(color: text),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: _form,
              ),
            ),
            _PinnedFooter(
              dark: dark,
              child: SCPrimaryButton(
                label: lang.getTranslation(Strings.proceed),
                icon: Icons.arrow_forward_rounded,
                onPressed: () => _form.submit(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinned bottom container with a top hairline + safe-area inset so the CTA
/// stays visible when the keyboard opens.
class _PinnedFooter extends StatelessWidget {
  final bool dark;
  final Widget child;
  const _PinnedFooter({required this.dark, required this.child});

  @override
  Widget build(BuildContext context) {
    final bg = dark ? AppColorsDark.bg : AppColors.bg;
    final line2 = dark ? AppColorsDark.line2 : AppColors.line2;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: line2, width: 1)),
      ),
      child: child,
    );
  }
}
