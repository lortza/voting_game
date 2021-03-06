import consumer from "./consumer"

document.addEventListener('turbolinks:load', function () {
  const getCookie = function (name) {
  	var value = "; " + document.cookie;
  	var parts = value.split("; " + name + "=");
  	if (parts.length == 2) return parts.pop().split(";").shift();
  };

  const displayIncomingPlayers = function(data) {
    const players = document.querySelector("#game-players");

    if (data.game_activated == true){
      window.location.href = data.destination_url
    }

    if (data.player_name === undefined || data.player_name === 'undefined') {
      console.log('player undefined')
    } else {
      players.insertAdjacentHTML('beforeend', `<p class='title is-4 mb-0'>${data.player_name}</p>`)
    }
  } //displayIncomingPlayers

  consumer.subscriptions.create({
      // This hash provides the params to the game_channel.rb
      channel: 'GameChannel',
      game_id: getCookie('game_id')
    }, {

      connected() {
        // Called when the subscription is ready for use on the server
        console.log('GameChannel: Connected')
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log('GameChannel: Disconnected')
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log('Received:')
        displayIncomingPlayers(data)

      }//received
    })//consumer.subscriptions
  })//addEventListener
