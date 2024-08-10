import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import Option "mo:base/Option";
import Result "mo:base/Result";


actor Votes{

   // Define a type to generate an ID, this ID will work as an index of a database.
  public type ProductId = Nat32;

  //  Creating a type of a Product
  public type ProductObject = {
    title : Text;
    votes : Nat;
  };

  // stable variables for data persistence
  //
  private stable var _nextProduct : ProductId = 0;

  private stable var _ProductObject : Trie.Trie<ProductId, ProductObject> = Trie.empty();

  // Create a product.
  // when a new product is created the function will return an Result that contains an #err or an #ok
  // The process is as follows: 
  //    - first we validate that the field is not empty 
  //    - if the field is empty the validation throw an error, else it will continue:
  //    - a let assigns the current state of _nextProduct, at startup this let is equivalent to 0. 
  //    - once the value is assigned, the _nextProduct variable has a value of 1 added to it to create an ID for the next product to be created.
  public func create(_product : ProductObject) : async Result.Result<Text, Text> {
    if (Text.equal(_product.title, "")) {
      return #err("No se admiten campos vacios");
    } else { 
      let stockId = _nextProduct;
      _nextProduct += 1;
      _ProductObject := Trie.replace(
        _ProductObject,
        key(stockId),
        Nat32.equal,
        ?_product,
      ).0;
      return #ok("Registro guardado con el número " # Nat32.toText(stockId) # "!");
    }
  };

  // Read a product.
  // the next function can read the records stored in Trie, comparing and finding if the specified ID exists, otherwise it will return a null value.
  public query func read(stockId : ProductId) : async ?ProductObject {
    let result = Trie.find(_ProductObject, key(stockId), Nat32.equal);
    return result;
  };

   // Update a product.
   // please @byNestorCode, do yourself a favor and finish documenting that jajaa xD
  public func update(stockId : ProductId, _product : ProductObject) : async Bool {
    let result = Trie.find(_ProductObject, key(stockId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      _ProductObject := Trie.replace(
        _ProductObject,
        key(stockId),
        Nat32.equal,
        ?_product,
      ).0;
    };
    return exists;
  };

  // Deelete product
  // ⚠️⚠️ pending and urgent

  // Create a trie key from a product identifier.
  private func key(x : ProductId) : Trie.Key<ProductId> {
    return { hash = x; key = x };
  };

  // The most important fuction, the votes:
  // within this function we can vote for our products by placing an existing stockId
  public func vote(stockId : ProductId) : async Bool {
    let result = Trie.find(_ProductObject, key(stockId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      let product = Option.get(result, { title = ""; votes = 0});
      let updatedProduct = { product with votes = product.votes + 1; };
      _ProductObject := Trie.replace(
        _ProductObject,
        key(stockId),
        Nat32.equal,
        ?updatedProduct,
      ).0;
    };
    return exists;
  };
};