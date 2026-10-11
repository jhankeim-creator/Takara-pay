export const checkAuthentication = () => {
  // Check both localStorage (remember me) and sessionStorage (current session)
  const localToken = localStorage.getItem("auth_token");
  const sessionToken = sessionStorage.getItem("auth_token");

  // User is authenticated if token exists in either storage
  return !!(localToken || sessionToken);
};

export const getAuthToken = () => {
  const localToken = localStorage.getItem("auth_token");
  const sessionToken = sessionStorage.getItem("auth_token");
  return localToken || sessionToken || null;
};
