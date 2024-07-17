import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";


actor Votes{

   // Definimos un type para generar un ID 
  public type stockId = Nat32;

  public type stockObject = {
    title : Text;
    votes : Nat;
  };

  private stable var _next : stockId = 0;

  private stable var _stockObject : Trie.Trie<stockId, stockObject> = Trie.empty();

  // Create a product.
  public func create(_product : stockObject) : async stockId {
    let stockId = _next;
    _next += 1;
    _stockObject := Trie.replace(
      _stockObject,
      key(stockId),
      Nat32.equal,
      ?_product,
    ).0;
    return stockId;
  };

  // Read a product.
  public query func read(stockId : stockId) : async ?stockObject {
    let result = Trie.find(_stockObject, key(stockId), Nat32.equal);
    return result;
  };

  // Create a trie key from a product identifier.
  private func key(x : stockId) : Trie.Key<stockId> {
    return { hash = x; key = x };
  };

  /* // funcion para votos
  public func vote(superheroId: Nat) : async () {
  let index = findIndexById(superheroId);
  if (index >= 0) {
    let superhero = superheroes[index];
    let updatedSuperhero = { superhero with votes = superhero.votes + 1 };
    superheroes := updateAtIndex(superheroes, index, updatedSuperhero);
  } else {
    // Manejar el caso donde no se encuentra el superhéroe
    // (esto puede depender de la lógica específica de tu aplicación)
  };
};

public func getVotes(superheroId: Nat) : async Nat {
  let index = findIndexById(superheroId);
  if (index >= 0) {
    return superheroes[index].votes;
  } else {
    // Manejar el caso donde no se encuentra el superhéroe
    // (esto puede depender de la lógica específica de tu aplicación)
    return 0;
  };
};

// Suponiendo que superheroes es una lista de Superhero
func findIndexById(id: Nat) : Int {
  let len = Array.length(superheroes);
  var index = -1;
  for (i in 0 .. len - 1) {
    if (superheroes[i].id == id) {
      index = i;
      break;
    };
  };
  return index; */
};