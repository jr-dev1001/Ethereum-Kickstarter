// converting hex to base 64
// hex_str0 = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d";
function hex2base() {
  var hex_str = document.getElementById("hexa").value;
  let base64 = "";
  for (let i = 0; i < hex_str.length; i++) {
    base64 += !((i - 1) & 1)
      ? String.fromCharCode(parseInt(hex_str.substring(i - 1, i + 1), 16))
      : "";
  }
  base64_str = btoa(base64);
  console.log(hex_str);
  document.getElementById("output").innerHTML = base64_str;
}

function base2hex() {

    
}
