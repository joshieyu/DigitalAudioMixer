# Deploying to the ECE server

Ensure you are on UCF campus WiFi or connected to the UCF VPN.
Then, from `/website`,
1. Run `npm run build`.
2. Run `scp -r ./dist/* fa24sp25g14@maverick.eecs.ucf.edu:~/`.
3. When asked, input the password (located in Trello, under Website>Login instructions).