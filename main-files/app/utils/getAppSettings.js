export async function getAppSettings() {
  try {
    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/app-settings`,
      {
        next: {
          revalidate: 1800, //30 minutes    
        },
      }
    );

    if (!res.ok) {
      throw new Error(`HTTP error! status: ${res.status}`);
    }

    const data = await res.json();
    return data?.data || null;
  } catch (error) {
    console.error("Error fetching app settings:", error);
    return null;
  }
}