use futures_util::stream::StreamExt;
use std::error::Error;
use tokio::net::TcpListener;
use tokio_tungstenite::accept_async;


#[tokio::main]
async fn main() {
    let addr = "0.0.0.0:9001";
    let listener = TcpListener::bind(&addr).await.expect("Failed to bind");
    println!("Listening on: {}", addr);

    while let Ok((stream, _)) = listener.accept().await {
        tokio::spawn(async move {
            let ws_stream = accept_async(stream)
                .await
                .expect("Error during the websocket handshake");

            println!(
                "New WebSocket connection: {}",
                ws_stream
                    .get_ref()
                    .peer_addr()
                    .expect("connected streams should have a peer address")
            );

            let (write, read) = ws_stream.split();

            read.for_each(|message| async {
                match message {
                    Ok(msg) => {
                        // if let Ok(text) = msg.to_text() {
                        //     if let Err(e) = i2c::write_message(&i2c, text.as_bytes()).await {
                        //         println!("I2C Error: {}", e);
                        //     }
                        // } else {
                        //     println!("Received non-text message");
                        // }
                        println!("Received: {}", msg);
                    }
                    Err(e) => println!("Error: {}", e),
                }
            })
            .await;
        });
    }
}

// #[cfg(target_os = "linux")]
// mod i2c {
//     use rppal::i2c::I2c;
//     use tokio::task;

//     pub async fn setup() -> Result<I2c, Box<dyn std::error::Error>> {
//         let i2c = task::spawn_blocking(|| {
//             let mut i2c = I2c::new().expect("Failed to initialize I2C");
//             i2c.set_slave_address(0x3C).expect("Failed to set I2C address");
//             i2c
//         })
//         .await?;

//         Ok(i2c)
//     }

//     pub async fn write_message(i2c: &I2c, message: &[u8]) -> Result<(), Box<dyn std::error::Error>> {
//         task::spawn_blocking(move || {
//             i2c.write(message).expect("Failed to write to I2C");
//         })
//         .await?;

//         Ok(())
//     }
// }