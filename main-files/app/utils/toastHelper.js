export const getToastMessage = (response) => {
  if (response?.message?.success?.length) {
    return {
      type: "success",
      text: response.message.success[0],
    };
  }

  if (response?.message?.error?.length) {
    return {
      type: "error",
      text: response.message.error[0],
    };
  }

  return {
    type: "error",
    text: "Something went wrong. Please try again.",
  };
};
