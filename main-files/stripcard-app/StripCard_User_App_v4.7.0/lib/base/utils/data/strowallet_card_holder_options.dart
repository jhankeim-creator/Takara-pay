/// Static (non-translated) option lists for the Strowallet card-holder form's
/// account_purpose / employment_status / occupation dropdowns.
///
/// Labels here are deliberately plain English literals, NOT routed through
/// Strings/.tr: the backend's language dictionary doesn't carry these keys,
/// so a translation lookup falls back to printing the raw key
/// (e.g. "accountPurposePersonal") instead of readable text.
class StrowalletCardHolderOption {
  const StrowalletCardHolderOption(this.value, this.label);

  /// Raw snake_case value sent to the API.
  final String value;

  /// Static English label shown to the user.
  final String label;
}

class StrowalletCardHolderOptions {
  static const List<StrowalletCardHolderOption> accountPurpose = [
    StrowalletCardHolderOption('personal', 'Personal'),
    StrowalletCardHolderOption('business', 'Business'),
    StrowalletCardHolderOption('savings', 'Savings'),
    StrowalletCardHolderOption('investment', 'Investment'),
    StrowalletCardHolderOption('travel', 'Travel'),
    StrowalletCardHolderOption('shopping', 'Shopping'),
    StrowalletCardHolderOption('bill_payment', 'Bill Payment'),
    StrowalletCardHolderOption('other', 'Other'),
  ];

  static const List<StrowalletCardHolderOption> employmentStatus = [
    StrowalletCardHolderOption('employed', 'Employed'),
    StrowalletCardHolderOption('self_employed', 'Self Employed'),
    StrowalletCardHolderOption('unemployed', 'Unemployed'),
    StrowalletCardHolderOption('student', 'Student'),
    StrowalletCardHolderOption('retired', 'Retired'),
  ];

  static const List<StrowalletCardHolderOption> occupation = [
    StrowalletCardHolderOption('engineer', 'Engineer'),
    StrowalletCardHolderOption('doctor', 'Doctor'),
    StrowalletCardHolderOption('teacher', 'Teacher'),
    StrowalletCardHolderOption('accountant', 'Accountant'),
    StrowalletCardHolderOption('business_owner', 'Business Owner'),
    StrowalletCardHolderOption('sales', 'Sales'),
    StrowalletCardHolderOption('freelancer', 'Freelancer'),
    StrowalletCardHolderOption('student', 'Student'),
    StrowalletCardHolderOption('other', 'Other'),
  ];
}
