// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"
import {ChartApp} from "./chartapp.js"
let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.
socket.connect()

class LiveUpdate {
  constructor() {
    this.channel = socket.channel("ex_monitor:rates", {})
  }

  join(){
    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })
  }

  setupElements(){
    switch(window.location.pathname) {
    case "/":
      this.setupIndexElements()
      break;
    case "/charts":
      this.setupChartElements()
        break;
    case "/balance":
      this.setupBalanceElements()
        break;
    default:
        break;
    }
  }

  setupIndexElements(){
    let btcusd = document.querySelector("#btc_usd")
    let btcmxn = document.querySelector("#btc_mxn")
    let ethusd = document.querySelector("#eth_usd")
    let ethmxn = document.querySelector("#eth_mxn")
    let ethimg = document.querySelector("#eth_img")
    let btcimg = document.querySelector("#btc_img")

    this.channel.on("btc_usd", payload => {
      btcusd.innerHTML = `${payload.body}`
    })

    this.channel.on("btc_mxn", payload => {
      btcmxn.innerHTML = `${payload.body}`
    })

    this.channel.on("eth_usd", payload => {
      ethusd.innerHTML = `${payload.body}`
    })

    this.channel.on("eth_mxn", payload => {
      ethmxn.innerHTML = `${payload.body}`
    })

    this.channel.on("eth_img", payload => {
      ethimg.src = `${payload.body}`
    })

    this.channel.on("btc_img", payload => {
      btcimg.src = `${payload.body}`
    })

    this.channel.on("listen_test", payload => {
      console.log(payload)
    })
  }

  setupChartElements(){
    var chart =  new ChartApp()
    chart.render()
    this.channel.on("btc_usd", payload => {
      chart.updateSeries2(payload.body)
    })

    this.channel.on("eth_usd", payload => {
      chart.updateSeries1(payload.body)
    })
  }

  setupBalanceElements(){
    let btcusd = document.querySelector("#btcBuyPrice")
    let ethusd = document.querySelector("#ethBuyPrice")
    this.channel.on("btc_usd", payload => {
      btcusd.innerHTML = `${payload.body} USD`
    })

    this.channel.on("eth_usd", payload => {
      ethusd.innerHTML = `${payload.body} USD`
    })
  }
}


let liveUpdate = new LiveUpdate
liveUpdate.join()
liveUpdate.setupElements()
export default socket
