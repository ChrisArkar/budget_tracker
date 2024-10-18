class AppValidator {
    String? validateEmail(value){
    if(value!.isEmpty){
      return "Please Enter an email";
    }
    RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if(!emailRegExp.hasMatch(value)){
      return "Please Enter a Valid Email";
    }
    return null;
  }
  String? validatePhoneNumber(value){
    if(value!.isEmpty){
      return "Please Enter a Phone Number";
    }
    if(value.length != 8){
      return "Please enter a 8-degit phone number";
    }
    return null;
  }
  String? validatePassword(value){
    if(value!.isEmpty){
      return "Please Enter a Password";
    }
    return null;
  }
  String? validateUsername(value){
    if(value!.isEmpty){
      return "Please Enter a Username";
    }
      return null;
  }
  String? isEmptyCheck(value){
    if(value!.isEmpty){
      return "Please Fill Details";
    }
      return null;
  }
}