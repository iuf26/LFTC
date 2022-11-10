const fs = require("fs");
const fs_promise = require("fs/promises");
const readlineSync = require("readline-sync");
const codesMapArray = [
  { code: 0, atom: "ID" },
  { code: 1, atom: "CONST" },
]; // { atom:id ,cod:}

class MyHashTable {
  #_table;
  #_indexForCohesionEvents;
  constructor(size) {
    this._size = size;
    this.#_table = [];
    for (let i = 0; i < size; i++) {
      this.#_table.push({ idx: i, value: null, link: [] });
    }
    this.#_indexForCohesionEvents = size;
  }

  getTab() {
    return this.#_table;
  }
  sumASCII(s) {
    let sum = 0;
    for (let i = 0; i < s.length; i++) {
      let code = s.charCodeAt(i);
      sum += code;
    }
    return sum;
  }

  getHashPosition(item) {
    const result = this.sumASCII(item) % this._size;
    return result;
  }

  addItem(item, FIP) {
    const ifExistsPosition = this.getItemPositionInSymbolsHashTable(item);
    if (ifExistsPosition !== -1) return ifExistsPosition;
    const hashPosition = this.getHashPosition(item);
    if (!this.#_table[hashPosition].value) {
      this.#_table[hashPosition].value = item;

      return this.#_table[hashPosition].idx;
    } else {
      let currentIndex =
        this.#_table[hashPosition].idx +
        this.#_table[hashPosition].link.length +
        1;
      let indexCopy = currentIndex + 1;
      this.#_table[hashPosition].link.push({
        idx: currentIndex,
        value: item,
      });
      const toAddBackInFip = [];
      for (const elem of FIP) {
        if (elem.positionInSymbolsTable) {
          const actualValueForPositionFunc = (pos) => {
            for (let i = 0; i < this.#_table.length; i++) {
              if (this.#_table[i].idx === pos) return this.#_table[i].value;
              for (let j = 0; j < this.#_table[i].link.length; j++) {
                if (this.#_table[i].link[j].idx === pos)
                  return this.#_table[i].link[j].value;
              }
            }
          };

          toAddBackInFip.push(
            actualValueForPositionFunc(elem.positionInSymbolsTable)
          );
        }
      }
      for (let i = hashPosition + 1; i < this.#_table.length; i++) {
        this.#_table[i].idx = indexCopy;
        indexCopy++;
        for (let j = 0; j < this.#_table[i].link.length; j++) {
          this.#_table[i].link[j].idx = indexCopy;
          indexCopy++;
        }
      }
      let indexToAddBackInFip = 0;
      for (const elem of FIP) {
        if (elem.positionInSymbolsTable) {
          const getNewPosition = (value) => {
            for (let i = 0; i < this.#_table.length; i++) {
              if (this.#_table[i].value === value) return this.#_table[i].idx;
              for (let j = 0; j < this.#_table[i].link.length; j++) {
                if (this.#_table[i].link[j].value === value)
                  return this.#_table[i].link[j].idx;
              }
            }
          };
          elem.positionInSymbolsTable = getNewPosition(
            toAddBackInFip[indexToAddBackInFip]
          );
          indexToAddBackInFip++;
        }
      }

      return currentIndex;
    }
  }

  getItemPositionInSymbolsHashTable(item) {
    const hashPosition = this.getHashPosition(item);
    const elem = this.#_table[hashPosition];
    if (elem.value === item) return elem.idx;
    for (const linkElem of elem.link)
      if (linkElem.value === item) return linkElem.idx;
    return -1;
  }
  get table() {
    return this.#_table;
  }
}

async function constructAtomsCodeTable2(filePath, hashTable) {
  let data = fs.readFileSync(filePath, "utf-8");
  data = data.replace(/[=]/gm, " = ");
  data = data.replace(/[;]/gm, " ; ");
  // data = data.replace(/[-]/gm, " - ");
  // data = data.replace(/[+]/gm, " + ");
  data = data.replace(/[>]/gm, " > ");
  data = data.replace(/[<]/gm, " < ");
  data = data.replace(/[!]/gm, " ! ");
  data = data.replace(/[(]/gm, " ( ");
  data = data.replace(/[)]/gm, " ) ");
  data = data.replace(/[\/]/gm, " / ");
  data = data.replace(/[%]/gm, " % ");
  data = data.replace(/[{]/gm, " { ");
  data = data.replace(/[}]/gm, " } ");
  data = data.replace(/[\t]/gm, "");
  data = data.replace(/[\r]/gm, "");
  data = data.replace(/[\n]/gm, " _ ");
  data = data.replace(/int/gm, " int ");
  data = data.replace(/float/gm, " float ");
  data = data.replace(/while/gm, " while ");
  data = data.replace(/for/gm, " for ");
  data = data.replace(/if/gm, " if ");
  data = data.replace(/cin/gm, " cin ");
  data = data.replace(/cout/gm, " cout ");
  data = data.replace(/#include/gm, " #include ");
  data = data.replace(/return/gm, " return ");
  data = data.replace(/main/gm, " main ");
  data = data.split(" ").filter((elem) => elem !== "");

  const FIP = [];
  let row = 1;
  let insideRowPosition = -1;
  const afOperators = new AF("af-OPERATORS.txt");
  await afOperators.procesAF();
  const afDelimitators = new AF("af-DELIM.txt");
  await afDelimitators.procesAF();

  //check for reserved keywords
  const afConst = new AF("af-INT-CONST.txt");
  await afConst.procesAF();
  const afID = new AF("af-ID.txt");
  await afID.procesAF();
  for (let i = 0; i < data.length; i++) {
    let ch = data[i];

    if (ch === "_") {
      row++;
      continue;
    }
    const currentCode = codesMapArray.length;
    if (
      (ch === "<" && data[i + 1] === "<") ||
      (ch === ">" && data[i + 1] === ">") ||
      (ch === "=" && data[i + 1] === "=") ||
      (ch === "!" && data[i + 1] === "=")
    ) {
      if (!codesMapArray.find((obj) => obj.atom === ch)) {
        codesMapArray.push({
          code: currentCode,
          atom: `${ch}${data[i + 1]}`,
        });
        FIP.push({
          atomCode: codesMapArray.find(
            (obj) => obj.atom === `${ch}${data[i + 1]}`
          ).code,
        });
      }
      i++;
      continue;
    }
    if (afDelimitators.checkIfSequenceAccepted(ch) === true) {
      if (!codesMapArray.find((obj) => obj.atom === ch)) {
        codesMapArray.push({ code: currentCode, atom: ch });
      }
      FIP.push({
        atomCode: codesMapArray.find((obj) => obj.atom === ch).code,
      });
      continue;
    }

    if (afOperators.checkIfSequenceAccepted(ch) === true) {
      if (!codesMapArray.find((obj) => obj.atom === ch)) {
        codesMapArray.push({ code: currentCode, atom: ch });
      }
      FIP.push({
        atomCode: codesMapArray.find((obj) => obj.atom === ch).code,
      });
      continue;
    }
    //RESERVED KEYWORDS
    const rk1 = new AF("rk-1.txt");
    const rk2 = new AF("rk-2.txt");
    const rk3 = new AF("rk-3.txt");
    await rk1.procesAF();
    await rk2.procesAF();
    await rk3.procesAF();
    if (
      rk1.checkIfSequenceAccepted(ch) === true ||
      rk2.checkIfSequenceAccepted(ch) === true ||
      rk3.checkIfSequenceAccepted(ch) === true
    ) {
      if (!codesMapArray.find((obj) => obj.atom === ch)) {
        codesMapArray.push({ code: codesMapArray.length, atom: ch });
      }
      FIP.push({
        atomCode: codesMapArray.find((obj) => obj.atom === ch).code,
      });
      continue;
    }
    if (afID.checkIfSequenceAccepted(ch) === true) {
      if (ch.length > 8)
        throw new Error(
          "Error at line " +
            row +
            " identificator exceded maximum length of 8:" +
            ch
        );
      let atomIndexInSymbolsTable = hashTable.addItem(ch, FIP);

      FIP.push({
        atomCode: 0,
        positionInSymbolsTable: atomIndexInSymbolsTable,
      });
      continue;
    }
    const afConstReal = new AF("af-real.txt");
    await afConstReal.procesAF();
    if (
      afConst.checkIfSequenceAccepted(ch) === true ||
      afConstReal.checkIfSequenceAccepted(ch) === true
    ) {
      let atomIndexInSymbolsTable = hashTable.addItem(ch, FIP);

      FIP.push({
        atomCode: 1,
        positionInSymbolsTable: atomIndexInSymbolsTable,
      });
    } else {
      throw new Error("Error at line " + row + " invalid constant " + ch);
    }
  }
  return FIP;
}

async function extractLexicalAtoms() {
  const programFile = "./program.txt";
  const hashTable = new MyHashTable(7);
  const FIP = await constructAtomsCodeTable2(programFile, hashTable);
  const symbolsTable = hashTable.table;

  console.log("Atoms codes: ");
  console.log(codesMapArray);
  console.log("Symbols Hash Table(TS)");
  symbolsTable.forEach((elem) => {
    console.log(elem);
  });
  console.log("FIP Table");
  console.log(FIP);
}

class AF {
  constructor(filename) {
    this.filename = filename;
    this.S = [];
    this.C = [];
    this.F = [];
    this.T = [];
    this.s0 = -1;
    this.data = "";
  }
  async procesAF() {
    try {
      this.data = await fs_promise.readFile(this.filename, {
        encoding: "utf8",
      });
    } catch (err) {
      console.log(err);
    }

    const lines = this.data
      .split("\n")
      .map((elem) => elem.replace(/[\r]/gm, ""));
    lines[0].split(" ").forEach((elem) => this.C.push(elem));
    this.s0 = lines[1];
    lines.splice(0, 2);
    lines.forEach((elem) => {
      let splitElemes = elem.split(" ");
      this.S.push(splitElemes[0]);
      if (splitElemes.slice(-1)[0] === "1") {
        this.F.push(splitElemes[0]);
      }
      for (let i = 1; i < splitElemes.length - 1; i++) {
        if (splitElemes[i] !== "-") {
          let splitElemesCopy = splitElemes[i].split(",");
          splitElemesCopy.forEach((elem) => {
            this.T.push([splitElemes[0], this.C[i - 1], elem]);
          });
        }
      }
    });
    this.C = [...this.S, ...this.C];
    return {
      S: this.S,
      C: this.C,
      F: this.F,
      T: this.T,
      s0: this.s0,
    };
  }

  checkIfSequenceAccepted(sequence) {
    sequence.replace(/[\r]/gm, "");

    let state = this.s0;
    let char;
    let prefix = false;
    while (sequence !== "") {
      char = sequence.slice(0, 1);

      let result = this.T.find((elem) => elem[0] === state && elem[1] === char);
      if (!result) {
        return prefix;
      }

      if (typeof prefix === "boolean") prefix = "";
      prefix = `${prefix}${char}`;
      state = result[2];
      sequence = sequence.slice(1);
    }
    if (!this.F.find((elem) => elem === state)) {
      return prefix;
    }
    return true;
  }
}

function compute(fileResult) {
  let cmd;
  let options =
    "1.states\n2.characters(alphabet)\n3.transitions\n4.final states\n5.check\n6.check valid prefix\n";
  while (true) {
    console.log(options);
    cmd = readlineSync.question("cmd  >> ");
    switch (cmd) {
      case "1":
        console.log(fileResult.S);
        break;
      case "2":
        console.log(fileResult.C);
        break;
      case "3":
        console.log(fileResult.T);
        break;
      case "4":
        console.log(fileResult.F);
        break;
      case "5":
        cmd = readlineSync.question("sequence >> ");
        let res = fileResult.checkIfSequenceAccepted(cmd);
        if (res && typeof res === "boolean") {
          console.log("Your sequence is valid\n");
        } else {
          console.log("!WARNING sequence not accepted\n");
        }
        break;
      case "6":
        cmd = readlineSync.question("sequence >> ");
        let res2 = fileResult.checkIfSequenceAccepted(cmd);
        if (res2 && !(typeof res2 === "boolean")) {
          console.log(`valid prefix:${res2}\n`);
        } else {
          if (res2 === true) {
            console.log("Your sequence is valid!\n");
          } else {
            console.log("No good available prefix\n");
          }
        }
        break;
      default:
        break;
    }
  }
}
const fileName = "input-af.txt";
const finiteID = "af-real.txt";
const run = async () => {
  let cmd;
  console.log("1.FILE\n2.PROMPT\n");
  cmd = readlineSync.question("cmd  >> ");
  if (cmd === "1") {
    //call af
    const fileResult = new AF(finiteID);
    await fileResult.procesAF();
    compute(fileResult);
  } else {
    if (cmd === "2") {
      cmd = readlineSync.question("cmd  >> ");
      let data = "";

      while (cmd !== "stop") {
        data = `${data}${cmd}\n`;
        cmd = readlineSync.question("cmd  >> ");
      }
      data = data.slice(0, -1);
      const fileResult = new AF(data);
      compute(fileResult);
    }
  }
};

extractLexicalAtoms();
//run();
