
class CommonJs {

    static showSuccessMessage(message) {
        $("#successText").text(message);
        $("#successMessage").show();
        setTimeout(() => $("#successMessage").fadeOut(1000), 8000);//
    }

    static showErrorMessage(message) {
        $("#errorText").text(message);
        $("#errorMessage").show();
        setTimeout(() => $("#errorMessage").fadeOut(1000), 8000);
    }
}
