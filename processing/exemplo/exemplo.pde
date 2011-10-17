  // Processing - Exemplo de escopo de saida
  import processing.serial.*; 		// Biblioteca necessaria para comunicacao serial entre o Processing e o Arduino

  Serial port; 				// atribuicao do nome "port" para a porta serial usada
  
  void envio() { 		        // exemplo de funcao para 
    int output = 255;
    byte [] matrix = new byte[40+1];
    matrix[0] = (byte) 0x55; 		// Checagem para manter consistencia no envio, se o Arduino receber valor diferente simplesmente ignora a informacao
    for(int i = 1; i < 41; i++){        // Laco de repeticao para preencher as 40 linhas
      matrix[i] = (byte) output;	// Para cada linha(0 < i < 41) eh atribuido um valor (0 <= output <= 255)
    }					// neste caso que corresponde a todos  LED's acesos
      port.write(matrix); 	        // Comando para envio porta serial para o Arduino
      println(matrix);                  // Imprime no console do Processing com a finalidade de depuracao do programa
  }
  
  void setup() { // O que for escrito aqui so sera executado uma unica vez
    port = new Serial(this, Serial.list()[0],9600);	// inicializacao da porta serial "port" com baudrate de 9600
    envio();    					// chamada da funcao envio
  }

  void draw() { //  O que for escrito aqui so sera executado em loop
  }
