import DownloadAuthenticatorApp from "../../../components/2fa/DownloadAuthenticatorApp";
import TwoFactorAuthenticator from "../../../components/2fa/TwoFactorAuthenticator";

export const metadata = {
  title: "Two Factor Authenticator",
};

function SecurityPage() {
  return (
    <>
      <div className="max-w-7xl mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 lg:gap-8">
          <TwoFactorAuthenticator />
          <DownloadAuthenticatorApp />
        </div>
      </div>
    </>
  );
}

export default SecurityPage;
