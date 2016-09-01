Making and Receiving Calls from the Browser
-------------------------------------------

As of 2016-08-29, the Twilio [quickstart docs](https://www.twilio.com/docs/quickstart)
do not contain examples for Elixir. Some examples for Elixir can be found in this tutorial.

To begin, create an empty Phoenix application called `Demo` and install and configure
ExTwilio per the instructions on the [README](README.md#configuration).

## Making a Call

Create a controller with a `show` action, and generate a Twilio capability
token with the specified application sid (it plays a welcome message)

```elixir
defmodule Demo.TwilioController do
  use Demo.Web, :controller

  def show(conn, _params) do
    token = ExTwilio.Capability.new
    |> ExTwilio.Capability.allow_client_outgoing("APabe7650f654fc34655fc81ae71caa3ff")
    |> ExTwilio.Capability.token

    render(conn, "show.html", token: token)
  end
end
```

Create a view template for the `show` action

```html
<script type="text/javascript"
  src="//media.twiliocdn.com/sdk/js/client/v1.3/twilio.min.js"></script>
<script type="text/javascript"
  src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js">
</script>
<script type="text/javascript">

/* Create the Client with a Capability Token */
Twilio.Device.setup("<%= @token %>", {debug: true});

/* Let us know when the client is ready. */
Twilio.Device.ready(function (device) {
    $("#log").text("Ready");
});

/* Report any errors on the screen */
Twilio.Device.error(function (error) {
    $("#log").text("Error: " + error.message);
});

Twilio.Device.connect(function (conn) {
    $("#log").text("Successfully established call");
});

/* Log a message when a call disconnects. */
Twilio.Device.disconnect(function (conn) {
    $("#log").text("Call ended");
});

/* Connect to Twilio when we call this function. */
function call() {
    Twilio.Device.connect();
}

/* A function to end a connection to Twilio. */
function hangup() {
    Twilio.Device.disconnectAll();
}
</script>

<button class="call" onclick="call();">
  Call
</button>

<!-- use an onclick action to hang up the call when the user presses
the button -->
<button class="hangup" onclick="hangup();">
  Hangup
</button>
<div id="log"></div>
```

Start Phoenix and open the page in the browser. Click the `Call` button and you should
hear the Twilio welcome message.

## Receiving a Call

Pending...
