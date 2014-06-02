package cliente;

import java.net.*;

public final class ServidorWeb {
	
	public static int port = 5555;
	public static void main(String argv[]) throws Exception {
		
		ServerSocket WebSocket = new ServerSocket(port);
<<<<<<< HEAD
		
		while (true) {
			
			Socket connectionSocket = WebSocket.accept();
			PeticionHttp request = new PeticionHttp(connectionSocket);
			Thread thread = new Thread(request);
			thread.start(); } } }
=======
		while (true) {
			Socket connectionSocket = WebSocket.accept();
			PeticionHttp request = new PeticionHttp(connectionSocket);
			Thread thread = new Thread(request);
			thread.start();
		}
	}	
}
>>>>>>> 071199d975116bfae59e3aeaea4fdfbe61b6ff2b
