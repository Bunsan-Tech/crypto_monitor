// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"
import {ChartApp} from "./linechart.js"
//var Chart = require('./linechart.js');
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

var series1 = [
          { x: new Date(2010, 0, 3), y: 650 },
          { x: new Date(2010, 0, 5), y: 700 },
          { x: new Date(2010, 0, 7), y: 710 },
          { x: new Date(2010, 0, 9), y: 658 },
          { x: new Date(2010, 0, 11), y: 734 },
          { x: new Date(2010, 0, 13), y: 963 },
          { x: new Date(2010, 0, 15), y: 847 },
          { x: new Date(2010, 0, 17), y: 853 },
          { x: new Date(2010, 0, 19), y: 869 },
          { x: new Date(2010, 0, 21), y: 943 },
          { x: new Date(2010, 0, 23), y: 970 }
          ]

var series2 = [
      { x: new Date(2010, 0, 3), y: 510 },
      { x: new Date(2010, 0, 5), y: 560 },
      { x: new Date(2010, 0, 7), y: 540 },
      { x: new Date(2010, 0, 9), y: 558 },
      { x: new Date(2010, 0, 11), y: 544 },
      { x: new Date(2010, 0, 13), y: 693 },
      { x: new Date(2010, 0, 15), y: 657 },
      { x: new Date(2010, 0, 17), y: 663 },
      { x: new Date(2010, 0, 19), y: 639 },
      { x: new Date(2010, 0, 21), y: 673 },
      { x: new Date(2010, 0, 23), y: 660 }
      ]

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("ex_monitor:rates", {})
let btcusd = document.querySelector("#btc_usd")
let btcmxn = document.querySelector("#btc_mxn")
let ethusd = document.querySelector("#eth_usd")
let ethmxn = document.querySelector("#eth_mxn")
let ethimg = document.querySelector("#eth_img")
let btcimg = document.querySelector("#btc_img")

var chart =  new ChartApp(series1,series2)
chart.render()

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("btc_usd", payload => {
  btcusd.innerHTML = `${payload.body}`
})

channel.on("btc_mxn", payload => {
  btcmxn.innerHTML = `${payload.body}`
})

channel.on("eth_usd", payload => {
  chart.updateSeries1()
  ethusd.innerHTML = `${payload.body}`
})

channel.on("eth_mxn", payload => {
  ethmxn.innerHTML = `${payload.body}`
})

channel.on("eth_img", payload => {
  ethimg.src = `${payload.body}`
})

channel.on("btc_img", payload => {
  btcimg.src = `${payload.body}`
})

export default socket
