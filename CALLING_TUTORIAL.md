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
    token =
      ExTwilio.Capability.new
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

Create a controller with a `show` action and generate a Twilio capability
token with the name _jenny_, which will allow Jenny to receive incoming calls

```elixir
defmodule Demo.TwilioController do
  use Demo.Web, :controller

  def show(conn, _params) do
    token =
      ExTwilio.Capability.new
      |> ExTwilio.Capability.allow_client_incoming("jenny")
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

/* Listen for incoming connections */
Twilio.Device.incoming(function (conn) {
  $("#log").text("Incoming connection from " + conn.parameters.From);
  // accept the incoming connection and start two-way audio
  conn.accept();
});

/* A function to end a connection to Twilio. */
function hangup() {
    Twilio.Device.disconnectAll();
}
</script>

<!-- use an onclick action to hang up the call when the user presses
the button -->
<button class="hangup" onclick="hangup();">
  Hangup
</button>
<div id="log"></div>
```

Next, we need to create a controller action that will render some TwiML instructing Twilio to connect any incoming calls to the client named _jenny_. There is a library called [ExTwiml](https://github.com/danielberkompas/ex_twiml) that provides a nice DSL for generating TwiML with Elixir. Add it as a dependency with `{:ex_twiml, "~> 2.1.0"}`.

Create the following controller action and module for rendering the TwiML

```elixir
defmodule Demo.TwilioController do
  use Demo.Web, :controller

  def show(conn, _params) do
    token =
      ExTwilio.Capability.new
      |> ExTwilio.Capability.allow_client_incoming("jenny")
      |> ExTwilio.Capability.token

    render(conn, "show.html", token: token)
  end

  # Note: By default, Twilio will POST to this endpoint
  def voice(conn, _params) do
    resp = Demo.Twiml.dial_jenny
    conn
    |> put_resp_content_type("text/xml")
    |> text(resp)
  end
end

defmodule Demo.Twiml do
  import ExTwiml

  def dial_jenny do
    twiml do
      # This should be your Twilio Number or verified Caller ID
      dial callerid: "+1XXXXXXX" do
        client "jenny"
      end
    end
  end
end
```

Once you've started your web server, you can expose your endpoint to the world with a tool like [Ngrok](https://ngrok.com/), pointing it to your development server on port 4000

    $ ngrok http 4000

Create a [TwiML application](https://www.twilio.com/console/voice/dev-tools/twiml-apps) on Twilio, which will tell Twilio where to get instructions for routing incoming calls. Set the URL to point to your `voice` endpoint exposed by Ngrok, e.g.

`http://xxxxxxxx.ngrok.io/voice` _Note: this URL will change every time you restart Ngrok_

In order to test making an inbound call to your client, you can use the `Call` button visible on the Twilio console page for your TwiML application. Open the page corresponding to the `show` action in your browser. Then, on a different computer, click the `Call` button on the Twilio console - you should be able to carry on a conversation through your browsers.
