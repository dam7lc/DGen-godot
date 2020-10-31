#include <iostream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

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

        string decimal_a_base(int base, int numero); //Funcion que se encarga de la conversion de decimal a cualquier base
        int base_a_decimal(int base, int numero); //Funcion que se encarga de la conversion de cualquier base a decimal
        int hex_a_dec(string str_numero); //Funcion que se encarga de la conversion de hexadecimal a decimal


        //Se pide y checa que el numero sea valido 
        while (1)
        {
            cout << "Ingresa el numero: " << endl;
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
                cout << "Error, Ingresa un numero valido" << endl; //Se identificó que es invalido y se vuelve a solicitar
            }
        }

        int opcion = 0;

        if (!bEsHexadecimal) { //Si no es hexadecimal se procede a solicitar que el usuario seleccione la base
            if (!bPuedeSerOctal) { //Si no puede ser octal entonces tampoco puede ser quinario ni binario 
                cout << "Ingresa la opcion que corresponde a la base del numero: " << endl;
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
                cout << "Ingresa la opcion que corresponde a la base del numero: " << endl;
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
                cout << "Ingresa la opcion que corresponde a la base del numero: " << endl;
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
                cout << "Ingresa la opcion que corresponde a la base del numero: " << endl;
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
            break;
        }
        
        char salir;
        cout << "¿ Desea Introducir otro numero(S/N) ?" << endl;
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
    string numero_a_añadir;
    while(1) { 
        mod = numero % base;
        numero_a_añadir = to_string(mod);
        if (base == 16) {
            switch(mod){
            case 10:
                numero_a_añadir = "A";
            break;
            case 11:
                numero_a_añadir = "B";
                break;
            case 12:
                numero_a_añadir = "C";
                break;
            case 13:
                numero_a_añadir = "D";
                break;
            case 14:
                numero_a_añadir = "E";
                break;
            case 15:
                numero_a_añadir = "F";
                break;
            default:
                break;
            }
        }
        resultadoInvertido.append(numero_a_añadir);
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
    cout << "digitos: " << numero_digitos << endl;
    for (int i = 0; i <= numero_digitos; i++) { 
        resultado += (pow(base, i) * digitos.at(i)); 
        
    }
    return resultado;
}

int hex_a_dec(string str_numero) {
    
    int resultado = 0;
    cout << str_numero.length() << endl;
    int tamaño = str_numero.length();
    int posicion = 0;
    cout << tamaño << endl;
    for(int x = tamaño-1; x >= 0; x--){
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