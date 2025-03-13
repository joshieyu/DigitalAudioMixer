use rppal::i2c::I2c;
use std::thread;
use std::time::Duration;

#[cfg(target_os = "linux")]
mod i2c {
    pub fn setup() {
        println!("Setting up I2C for Linux");
        // Add your I2C setup code here
    }
}

#[cfg(target_os = "macos")]
mod i2c {
    pub fn setup() {
        println!("I2C is not supported on macOS");
    }
}

fn main() {
    #[cfg(target_os = "linux")]
    {
        // Initialize the I2C bus
        let mut i2c = I2c::new().expect("Failed to initialize I2C");

        // Set the I2C address of the device (replace 0x40 with your device's address)
        i2c.set_slave_address(0x3C)
            .expect("Failed to set I2C address");

        // Message to send
        let message = b"hello world";

        // Send the message every second
        loop {
            i2c.write(message).expect("Failed to write to I2C");
            println!("Sent: hello world");
            thread::sleep(Duration::from_secs(1));
        }
    }

    #[cfg(target_os = "macos")]
    {
        println!("I2C is not supported on macOS");
    }
}
