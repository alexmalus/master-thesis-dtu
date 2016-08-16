App.messages = App.cable.subscriptions.create('MessagesChannel', {  
  received: function(data) {
    $("#messages").removeClass('hidden')
    return $('#messages').append(this.renderMessage(data));
  },
  renderMessage: function(data) {
    return "<p> <b>" + data.user + "(" + data.created_at + ")" + ": </b>" + $('<div/>').text(data.message).html() + "</p>";
  }
});