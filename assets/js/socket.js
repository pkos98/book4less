// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import { Socket } from "phoenix"

let socket = new Socket("/socket", { params: { token: window.userToken } })
let searchInput = document.getElementById("searchbox");
let suggestionBox = document.getElementById("livesearch")

socket.connect()

window.searchFor = (suggestion) => {
  console.log("Clicked " + suggestion);
  searchInput.value = suggestion;
};
// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("search:autocomplete", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
channel.on("new_suggestions", resp => {
  console.log(resp);
  suggestionBox.style.border = "1px solid #A5ACB2";
  suggestionBox.innerHTML = "";
  resp.suggestions.forEach(suggestion => {
    suggestionBox.innerHTML += 
    "<a onclick=\"window.searchFor(this.innerText);\">" +
    suggestion.query +
    "</a><br>";
  })
});


document.getElementById("searchbox").addEventListener("keyup", event => {
  let searchText = searchInput.value;
  if (!searchText || event.keyCode == 13) {
    suggestionBox.innerHTML = "";
    suggestionBox.style.border = "0px";
    return;
  }
  channel.push("search_input", { input: searchText });
});