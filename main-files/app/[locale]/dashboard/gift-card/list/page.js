import GiftCardListTwo from "../../../../components/Gift-Card/GiftCardListTwo";
// import GiftCardList from "../../../../components/Gift-Card/GiftCardList"; // For Dynamic Route

export const metadata = {
  title: "Gift Cards",
};

export default function Page() {
  // return <GiftCardList />; For Dynamic Route
  return <GiftCardListTwo />;
}
