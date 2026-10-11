"use client";
import ChangePasswordCard from "../../../components/Profile/ChangePasswordCard";
import MyProfileCard from "../../../components/Profile/MyProfileCard";

export const metadata = {
  title: "My Profile",
};

function ProfilePage() {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-10">
      <div className="order-1 lg:order-1">
        <MyProfileCard />
      </div>
      <div className="order-2 lg:order-2">
        <ChangePasswordCard />
      </div>
    </div>
  );
}

export default ProfilePage;
