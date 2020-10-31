#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <cmath>
#include <iomanip>
#include <limits>

using namespace std;

string decimal_a_base(int base, int numero); //Funcion que se encarga de la conversion de decimal a cualquier base
int base_a_decimal(int base, int numero); //Funcion que se encarga de la conversion de cualquier base a decimal
int hex_a_dec(string str_numero); //Funcion que se encarga de la conversion de hexadecimal a decimal
void convertir_unidades(int numero); //Funcion que realiza la conversion de unidades utilizando el valor DECIMAL !!
float prefijo_mayor(float numero); //Funcion que obtiene el valor en el prefijo inmediato mayor (ej, megas a gigas)
float prefijo_menor(float numero); //Funcion que obtiene el valor en el prefijo inmediato menor (ej, gigas a megas)
float a_bytes(float bits); // Funcion que convierte de bits a bytes
float a_bits(float bytes); // Funcion que convierte de bytes a bits

int main() {
    while (1) {
        //Se inicializan las variables
        bool bPuedeSerBinario = true;
        bool bEsHexadecimal = false;
        bool bPuedeSerQuinario = true;
        bool bPuedeSerOctal = true;
        string stringNumero;
        int numero = 0;
        int decimal = 0;
        string octal;
        string binario;
        string quinario;
        string hexadecimal;

        
       
        //Se pide y checa que el numero sea valido 
        while (1)
        {
            cout << endl << "Ingresa el numero: " << endl;
            bPuedeSerBinario = true;
            bPuedeSerOctal = true;
            bPuedeSerQuinario = true;
            bEsHexadecimal = false;
            bool bEsNumeroValido = true;

            cin >> stringNumero;
            for (int i = 0; i < stringNumero.size(); i++) { //Se lee caracter por caracter
                if (!isdigit(stringNumero[i])) { //Si no es numero se identifica si es un caracter Hexadecimal
                    char caracter = stringNumero[i];
                    if (caracter == 'A' || caracter == 'a' || caracter == 'B' || caracter == 'b' || caracter == 'C' || caracter == 'c' || caracter == 'D' || caracter == 'd'
                        || caracter == 'E' || caracter == 'e' || caracter == 'F' || caracter == 'f') {
                        bEsHexadecimal = true;
                        bPuedeSerBinario = false;
                        bPuedeSerOctal = false;
                        bPuedeSerQuinario = false;
                    }
                    else {
                        bEsNumeroValido = false;
                    }
                }
                else { //Si es un numero se identifica si puede ser binario, quinario u octal
                    int digito = stringNumero[i] - '0';
                    if (digito > 1) {
                        bPuedeSerBinario = false;

                    }
                    if (digito > 4) {
                        bPuedeSerQuinario = false;
                    }
                    if (digito > 7) {
                        bPuedeSerOctal = false;
                    }
                }
            }
            if (bEsNumeroValido) {
                break; //Si el numero es valido se deja de solicitar un numero valido
            }
            else {
                cout << "Error, Ingresa un numero valido" << endl; //Se identific� que es invalido y se vuelve a solicitar
            }
        }

        int opcion = 0;

        if (!bEsHexadecimal) { //Si no es hexadecimal se procede a solicitar que el usuario seleccione la base
            if (!bPuedeSerOctal) { //Si no puede ser octal entonces tampoco puede ser quinario ni binario 
                cout << endl << "Ingresa la opcion que corresponde a la base del numero: " << endl;
                cout << "3) Base 10 (Decimal)" << endl;
                cout << "5) Base 16 (Hexadecimal)" << endl;
                while (1) //Se verifica que el numero ingresado sea valido
                {
                    cin >> opcion;
                    if (!cin.fail() && (opcion == 3 || opcion == 5)) {
                        break;
                    }
                    cin.clear();
                    cin.ignore(10000, '\n');
                    cout << "Ingresa una opcion valida ";
                }
            }
            else if (!bPuedeSerQuinario) { //Si no puede ser quinario se quita el binario y el qinario
                cout << endl << "Ingresa la opcion que corresponde a la base del numero: " << endl;
                cout << "2) Base 8 (Octal)" << endl;
                cout << "3) Base 10 (Decimal)" << endl;
                cout << "5) Base 16 (Hexadecimal)" << endl;
                while (1) //Se verifica que el numero ingresado sea valido
                {
                    cin >> opcion;
                    if (!cin.fail() && (opcion == 2 || opcion == 3 || opcion == 5)) {
                        break;
                    }
                    cin.clear();
                    cin.ignore(10000, '\n');
                    cout << "Ingresa una opcion valida ";
                }
            }
            else if (!bPuedeSerBinario) { //Si no puede ser binario se quita esa opcion para evitar errores
                cout << endl << "Ingresa la opcion que corresponde a la base del numero: " << endl;
                cout << "1) Base 5 (Quinario)" << endl;
                cout << "2) Base 8 (Octal)" << endl;
                cout << "3) Base 10 (Decimal)" << endl;
                cout << "5) Base 16 (Hexadecimal)" << endl;
                while (1) //Se verifica que el numero ingresado sea valido
                {
                    cin >> opcion;
                    if (!cin.fail() && (opcion == 1 || opcion == 2 || opcion == 3 || opcion == 5)) {
                        break;
                    }
                    cin.clear();
                    cin.ignore(10000, '\n');
                    cout << "Ingresa una opcion valida ";
                }
            }


            else { //Si puede ser binario se incluye la opcion 
                cout << endl << "Ingresa la opcion que corresponde a la base del numero: " << endl;
                cout << "1) Base 5 (Quinario)" << endl;
                cout << "2) Base 8 (Octal)" << endl;
                cout << "3) Base 10 (Decimal)" << endl;
                cout << "4) Base 2 (Binario)" << endl;
                cout << "5) Base 16 (Hexadecimal)" << endl;

                while (1) //Se verifica que el numero ingresado sea valido
                {
                    cin >> opcion;
                    if (!cin.fail() && (opcion == 1 || opcion == 2 || opcion == 3 || opcion == 4 || opcion == 5)) {
                        break;
                    }
                    cin.clear();
                    cin.ignore(10000, '\n');
                    cout << "Ingresa una opcion valida ";
                }
            }



        }
        else {
            opcion = 5; //Si es hexadecimal automaticamente se procede a esa opcion
        }

        try {
            numero = stoi(stringNumero);
        }
        catch (std::invalid_argument) {
            cout << "El numero es hexadecimal ";
        }


        switch (opcion) {

        case 1: //Quinario
            decimal = base_a_decimal(5, numero);
            octal = decimal_a_base(8, decimal);
            binario = decimal_a_base(2, decimal);
            hexadecimal = decimal_a_base(16, decimal);
            cout << numero << " quinario a decimal es igual a " << decimal << endl;
            cout << numero << " quinario a octal es igual a " << octal << endl;
            cout << numero << " quinario a binario es igual a " << binario << endl;
            cout << numero << " quinario a hexadecimal es igual a " << hexadecimal << endl;
            convertir_unidades(decimal);
            break;
        case 2: //Octal
            decimal = base_a_decimal(8, numero);
            quinario = decimal_a_base(5, decimal);
            binario = decimal_a_base(2, decimal);
            hexadecimal = decimal_a_base(16, decimal);
            cout << numero << " octal a decimal es igual a " << decimal << endl;
            cout << numero << " octal a quinario es igual a " << quinario << endl;
            cout << numero << " octal a binario es igual a " << binario << endl;
            cout << numero << " octal a hexadecimal es igual a " << hexadecimal << endl;
            convertir_unidades(decimal);
            break;
        case 3: //Decimal
            octal = decimal_a_base(8, numero);
            quinario = decimal_a_base(5, numero);
            binario = decimal_a_base(2, numero);
            hexadecimal = decimal_a_base(16, numero);
            cout << numero << " decimal a octal es igual a " << octal << endl;
            cout << numero << " decimal a quinario es igual a " << quinario << endl;
            cout << numero << " decimal a binario es igual a " << binario << endl;
            cout << numero << " decimal a hexadecimal es igual a " << hexadecimal << endl;
            convertir_unidades(decimal);
            break;
        case 4: //Binario
            decimal = base_a_decimal(2, numero);
            quinario = decimal_a_base(5, decimal);
            octal = decimal_a_base(8, decimal);
            hexadecimal = decimal_a_base(16, decimal);
            cout << numero << " binario a decimal es igual a " << decimal << endl;
            cout << numero << " binario a quinario es igual a " << quinario << endl;
            cout << numero << " binario a octal es igual a " << octal << endl;
            cout << numero << " binario a hexadecimal es igual a " << hexadecimal << endl;
            convertir_unidades(decimal);
            break;
        case 5: //Hexadecimal
            decimal = hex_a_dec(stringNumero);
            quinario = decimal_a_base(5, decimal);
            binario = decimal_a_base(2, decimal);
            octal = decimal_a_base(8, decimal);
            cout << stringNumero << " hexadecimal a decimal es igual a " << decimal << endl;
            cout << stringNumero << " hexadecimal a quinario es igual a " << quinario << endl;
            cout << stringNumero << " hexadecimal a octal es igual a " << octal << endl;
            cout << stringNumero << " hexadecimal a binario es igual a " << binario << endl;
            convertir_unidades(decimal);
            break;
        }
        
        char salir;
        cout << endl << "� Desea Introducir otro numero(S/N) ?" << endl;
        while (1) //Se verifica que el numero ingresado sea valido
        {
            cin >> salir;
            if (!cin.fail() && (salir == 'S' || salir == 'N' )) {
                break;
            }
            cin.clear();
            cin.ignore(10000, '\n');
            cout << "Ingresa una opcion valida ";
        }
        if (salir == 'N') {
            break;
        }
    }
    

    return 0; //Salida del programa
}

string decimal_a_base(int base, int numero) 
{
    string resultadoInvertido;
    int mod;
    string numero_a_anadir = "";
    while(1) { 
        mod = numero % base;
        numero_a_anadir = to_string(mod);
        if (base == 16) {
            switch(mod){
            case 10:
                numero_a_anadir = "A";
            break;
            case 11:
                numero_a_anadir = "B";
                break;
            case 12:
                numero_a_anadir = "C";
                break;
            case 13:
                numero_a_anadir = "D";
                break;
            case 14:
                numero_a_anadir = "E";
                break;
            case 15:
                numero_a_anadir = "F";
                break;
            default:
                break;
            }
        }
        resultadoInvertido.append(numero_a_anadir);
        numero = numero / base; 
        if (numero <= 0) {
            break;
        }
    }
    string resultado;
    for (int n = resultadoInvertido.length() - 1; n >= 0; n--) {
        resultado.push_back(resultadoInvertido[n]);
    }
    return resultado;
}

int base_a_decimal(int base, int numero) //8 1234 
{
    int numero_digitos = 1;
    int resultado = 0; 
    vector<int> digitos;
    digitos.push_back(numero % 10); 
    while ((numero / 10) > 1) {
        
        numero = numero / 10;
        
        digitos.push_back(numero % 10);
        numero_digitos++; 
    }
    numero = numero / 10;
    digitos.push_back(numero % 10); // 0
    for (int i = 0; i <= numero_digitos; i++) { 
        resultado += (pow(base, i) * digitos.at(i)); 
        
    }
    return resultado;
}

int hex_a_dec(string str_numero) {
    
    int resultado = 0;
    int tamano = str_numero.length();
    int posicion = 0;
    for(int x = tamano-1; x >= 0; x--){
        int string_numero = 0;
        
        
        switch (str_numero.at(x)) {
        case 'A':
        case 'a':
            string_numero = 10;
            break;
        case 'B':
        case 'b':
            string_numero = 11;
            break;
        case 'C':
        case 'c':
            string_numero = 12;
            break;
        case 'D':
        case 'd':
            string_numero = 13;
            break;
        case 'E':
        case 'e':
            string_numero = 14;
            break;
        case 'F':
        case 'f':
            string_numero = 15;
            break;
        default:
            string_numero = str_numero[x] - '0';
        }
        resultado += (pow(16, posicion) * string_numero);
        posicion++;
    }
    return resultado;
}

void convertir_unidades(int numero){
    cout << endl << "Identificar la unidad de memoria para la conversion con el valor decimal" << endl;
    cout << "1) bits" << endl;
    cout << "2) Bytes" << endl;
    cout << "3) KiloBytes" << endl;
    cout << "4) MegaBytes" << endl;
    cout << "5) GigaBytes" << endl;
    cout << "6) TeraBytes" << endl;
    int opcion;
    while (1) //Se verifica que el numero ingresado sea valido
    {
        cin >> opcion;
        if (!cin.fail() && (opcion == 1 || opcion == 2 || opcion == 3 || opcion == 4 || opcion == 5 || opcion == 6)) {
            break;
        }
        cin.clear();
        cin.ignore(10000, '\n');
        cout << "Ingresa una opcion valida ";
    }
    float bits;
    float bytes;
    float kilos;
    float megas;
    float gigas;
    float teras;
    switch(opcion){
        case 1: //son bits
            bytes = a_bytes(numero);
            kilos = prefijo_mayor(bytes);
            megas = prefijo_mayor(kilos);
            gigas = prefijo_mayor(megas);
            teras = prefijo_mayor(gigas);
            cout << numero << " bits equivalen a: " << endl;
            cout << fixed << fixed << setprecision(6) << bytes << " Bytes" << endl;
            cout << fixed << fixed << setprecision(6) << kilos << " KB" << endl;
            cout << fixed << fixed << setprecision(6) << megas << " MB" << endl;
            cout << fixed << fixed << setprecision(6) << gigas << " GB" << endl;
            cout << fixed << fixed << setprecision(6) << teras << " TB" << endl;
        break;
        case 2: //son bytes
            bits = a_bits(numero);
            kilos = prefijo_mayor(numero);
            megas = prefijo_mayor(kilos);
            gigas = prefijo_mayor(megas);
            teras = prefijo_mayor(gigas);
            cout << numero << " Bytes equivalen a: " << endl;
            cout << fixed << fixed << setprecision(6) << bits << " bits" << endl;
            cout << fixed << fixed << setprecision(6) << kilos << " KB" << endl;
            cout << fixed << fixed << setprecision(6) << megas << " MB" << endl;
            cout << fixed << fixed << setprecision(6) << gigas << " GB" << endl;
            cout << fixed << fixed << setprecision(6) << teras << " TB" << endl;
        break;
        case 3: //son KB
            bytes = prefijo_menor(numero);
            bits = a_bits(bytes);
            megas = prefijo_mayor(numero);
            gigas = prefijo_mayor(megas);
            teras = prefijo_mayor(gigas);
            cout << numero << " KiloBytes equivalen a: " << endl;
            cout << fixed << fixed << setprecision(6) << bits << " bits" << endl;
            cout << fixed << fixed << setprecision(6) << bytes << " Bytes" << endl;
            cout << fixed << fixed << setprecision(6) << megas << " MB" << endl;
            cout << fixed << fixed << setprecision(6) << gigas << " GB" << endl;
            cout << fixed << fixed << setprecision(6) << teras << " TB" << endl;
        break;
        case 4: //son MB
            kilos = prefijo_menor(numero);
            bytes = prefijo_menor(kilos);
            bits = a_bits(bytes);
            gigas = prefijo_mayor(numero);
            teras = prefijo_mayor(gigas);
            cout << numero << " MegaBytes equivalen a: " << endl;
            cout << fixed << fixed << setprecision(6) << bits << " bits" << endl;
            cout << fixed << fixed << setprecision(6) << bytes << " Bytes" << endl;
            cout << fixed << fixed << setprecision(6) << kilos << " KB" << endl;
            cout << fixed << fixed << setprecision(6) << gigas << " GB" << endl;
            cout << fixed << fixed << setprecision(6) << teras << " TB" << endl;
        break;
        case 5: //son GB
            megas = prefijo_menor(numero);
            kilos = prefijo_menor(megas);
            bytes = prefijo_menor(kilos);
            bits = a_bits(bytes);
            teras = prefijo_mayor(gigas);
            cout << numero << " GigaBytes equivalen a: " << endl;
            cout << fixed << fixed << setprecision(6) << bits << " bits" << endl;
            cout << fixed << fixed << setprecision(6) << bytes << " Bytes" << endl;
            cout << fixed << fixed << setprecision(6) << kilos << " KB" << endl;
            cout << fixed << fixed << setprecision(6) << megas << " MB" << endl;
            cout << fixed << fixed << setprecision(6) << teras << " TB" << endl;
        break;
        case 6: //son TB
            gigas = prefijo_menor(numero);
            megas = prefijo_menor(gigas);
            kilos = prefijo_menor(megas);
            bytes = prefijo_menor(kilos);
            bits = a_bits(bytes);
            
            cout << numero << " TeraBytes equivalen a: " << endl;
            cout << fixed << fixed << setprecision(6) << bits << " bits" << endl;
            cout << fixed << fixed << setprecision(6) << bytes << " Bytes" << endl;
            cout << fixed << fixed << setprecision(6) << kilos << " KB" << endl;
            cout << fixed << fixed << setprecision(6) << megas << " MB" << endl;
            cout << fixed << fixed << setprecision(6) << gigas << " GB" << endl;
        break;
        default:
        cout << "Esto nunca se deberia de ejecutar :O" << endl;
        break;
    }
}

float prefijo_mayor(float numero){
    return (numero / 1024);
}

float prefijo_menor(float numero){
    return (numero * 1024);
}

float a_bytes(float bits){
    return (bits / 8);
}

float a_bits(float bytes){
    return (bytes * 8);
}