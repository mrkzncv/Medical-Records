pragma solidity ^0.5.0; // https://github.com/ethereum/solidity https://docs.soliditylang.org/en/v0.4.21/types.html 
/* application binary interface, ABI
* набор соглашений для доступа приложения к операционной системе и другим низкоуровневым сервисам,
* спроектированный для переносимости исполняемого кода между машинами, имеющими совместимые ABI.
* ABIEncoderV2 return an array from a function - ABI decoder which supports structs and arbitrarily nested
*/
pragma experimental ABIEncoderV2;

contract MedicalRecordsChain {

  // У каждого пользователя есть список документов, выписок, справок и т.д. //

  mapping (address => string[]) public documents;   // mapping (тип_ключей => тип_значений) имя_переменной; Mappings can be seen as hash tables
  // Public функция видна всем

  // обавляем новую медицинскую запись. //
  // глобальная переменная msg //
  // function имя_функции(входные_параметры) public constant returns (тип_возвращаемого_значения) // 
  // “memory”, this is used to hold temporary values // 
  function addDocument(string memory documentHash) public returns (uint) { // uint — сокращенно от unsigned int — Целое положительное число.//
      // address Holds a 20 byte value (size of an Ethereum address)//
    address from = msg.sender;   // msg.sender  — это адрес того, кто выполняет контракт в данный момент. тип этого поля address
    // push возвращает размер array
    return documents[from].push(documentHash) - 1; // Вернет индекс медицинской записи
  }

  // .push() and .push(value) can be used to append a new element at the end of the array //

  // Вернет все записи по пользователю //
  function getDocuments(address user) public view returns (string[] memory) { // View functions ensure that they will not modify the state //
    return documents[user];
  }

  /*
   * Функция выдачи пользователем прав на просмотр его документов врачами, медурчерждениями, страховыми кампаниями
   * Доступ предоставляется путём добавления своего идентификатора в список пациентов выбранного актора
   * Отменить право доступа можно путём удаления своего 
   */
  mapping (address => address[]) public doctorsPermissions;

  // Предоставление доступа к просмотру всех документов и записей

  function giveAccessToDoctor(address doctor) public {
    doctorsPermissions[doctor].push(msg.sender); // добавление своего адреса в список адресов врача/медучреждения и т д //
  }

  // Отмена доступа

  function revokeAccessFromDoctor(address doctor, uint index) public {
    require(doctorsPermissions[doctor][index] == msg.sender, 'Доступ можно ограничить на просмотр только ваших персональных документов!'); // Проверка условий //
    delete doctorsPermissions[doctor][index];
  }

  // Просмотр идентификаторов всех пациентов, предоставивших доступ на просмотр документов этому пользователю

  function getDoctorsPermissions(address doctor) public view returns (address[] memory) {
    return doctorsPermissions[doctor];
  }
}