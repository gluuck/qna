import consumer from "channels/consumer"

consumer.subscriptions.create("QuestionChannel", {
  
  connected() {
    console.log(' connected question!!!!!!')    
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
   // const question = getElementsById('.questions')
    //question.append(data)
    //console.log(data)
  }
});
