#include <algorithm>
#include <functional>
#include <random>
#include <unordered_set>

class SearchStrategy {
private:
  
  // Default values
  const size_t nHashes{200};
  const size_t rows{2};
  const size_t bands{100};
  std::vector<uint32_t> randomHashFuncs;

public:
  SearchStrategy() = default;

  SearchStrategy(size_t rows, size_t bands) : nHashes(rows * bands), rows(rows), bands(bands) {
    updateRandomHashFunctions(nHashes - 1);
  };

  uint32_t fnv1a(const std::vector<uint32_t> &Seq) {
    uint32_t hash = 2166136261;
    int len = Seq.size();

    for (int i = 0; i < len; i++) {
      hash ^= Seq[i];
      hash *= 1099511628211;
    }

    return hash;
  }

  uint32_t fnv1a(const std::vector<uint32_t> &Seq, uint32_t newHash) {
    uint32_t hash = newHash;
    int len = Seq.size();

    for (int i = 0; i < len; i++) {
      hash ^= Seq[i];
      hash *= 1099511628211;
    }

    return hash;
  }

  // Generate shingles using a single hash -- unused as not effective for function merging
  template <uint32_t K> 
  std::vector<uint32_t>& 
  generateShinglesSingleHashPipelineTurbo(const std::vector<uint32_t> &Seq, std::vector<uint32_t> &ret) {
    uint32_t pipeline[K] = {0};
    int len = Seq.size();

    ret.resize(nHashes);

    std::unordered_set<uint32_t> set;
    // set.reserve(nHashes);
    uint32_t last = 0;

    for (int i = 0; i < len; i++) {

      for (int k = 0; k < K; k++) {
        pipeline[k] ^= Seq[i];
        pipeline[k] *= 1099511628211;
      }

      // Collect head of pipeline
      if (last <= nHashes - 1) {
        ret[last++] = pipeline[0];

        if (last > nHashes - 1) {
          std::make_heap(ret.begin(), ret.end());
          std::sort_heap(ret.begin(), ret.end());
        }
      }

      if (pipeline[0] < ret.front() && last > nHashes - 1) {
        if (set.find(pipeline[0]) == set.end()) {
          set.insert(pipeline[0]);

          ret[last] = pipeline[0];

          std::sort_heap(ret.begin(), ret.end());
        }
      }

      // Shift pipeline
      for (int k = 0; k < K - 1; k++) {
        pipeline[k] = pipeline[k + 1];
      }
      pipeline[K - 1] = 2166136261;
    }

    return ret;
  }

  // Generate MinHash fingerprint with multiple hash functions
  template <uint32_t K>
  std::vector<uint32_t> &
  generateShinglesMultipleHashPipelineTurbo(const std::vector<uint32_t> &Seq, std::vector<uint32_t> &ret) {
    uint32_t pipeline[K] = {0};
    uint32_t len = Seq.size();

    uint32_t smallest = std::numeric_limits<uint32_t>::max();

    std::vector<uint32_t> shingleHashes(len);

    ret.resize(nHashes);

    // Pipeline to hash all shingles using fnv1a
    // Store all hashes
    // While storing smallest
    // Then for each shingle hash, rehash with an XOR of 32 bit random number
    // and store smallest Do this nHashes-1 times to obtain nHashes minHashes
    // quickly Sort the hashes at the end

    for (uint32_t i = 0; i < len; i++) {
      for (uint32_t k = 0; k < K; k++) {
        pipeline[k] ^= Seq[i];
        pipeline[k] *= 1099511628211;
      }

      // Collect head of pipeline
      if (pipeline[0] < smallest)
        smallest = pipeline[0];
      shingleHashes[i] = pipeline[0];

      // Shift pipeline
      for (uint32_t k = 0; k < K - 1; k++)
        pipeline[k] = pipeline[k + 1];
      pipeline[K - 1] = 2166136261;
    }

    ret[0] = smallest;

    // Now for each hash function, rehash each shingle and store the smallest
    // each time
    for (uint32_t i = 0; i < randomHashFuncs.size(); i++) {
      smallest = std::numeric_limits<uint32_t>::max();

      for (uint32_t j = 0; j < shingleHashes.size(); j++) {
        uint32_t temp = shingleHashes[j] ^ randomHashFuncs[i];

        if (temp < smallest)
          smallest = temp;
      }

      ret[i + 1] = smallest;
    }

    std::sort(ret.begin(), ret.end());

    return ret;
  }

  void updateRandomHashFunctions(size_t num) {
    size_t old_num = randomHashFuncs.size();
    randomHashFuncs.resize(num);

    // if we shrunk the vector, there is nothing more to do
    if (num <= old_num)
      return;

    // If we enlarged it, we need to generate new random numbers
    // std::random_device rd;
    // std::mt19937 gen(rd());
    std::mt19937 gen(0);
    std::uniform_real_distribution<> distribution(
        0, std::numeric_limits<uint32_t>::max());

    // generating a random integer:
    for (size_t i = old_num; i < num; i++)
      randomHashFuncs[i] = distribution(gen);
  }

  std::vector<uint32_t> &generateBands(const std::vector<uint32_t> &minHashes,
                                       std::vector<uint32_t> &LSHBands) {
    LSHBands.resize(bands);

    // Generate a hash for each band
    for (size_t i = 0; i < bands; i++) {
      // Perform fnv1a on the rows
      auto first = minHashes.begin() + (i * rows);
      auto last = minHashes.begin() + (i * rows) + rows;
      LSHBands[i] = fnv1a(std::vector<uint32_t>{first, last});
    }

    // Remove duplicate bands -- no need to place twice in the same bucket
    std::sort(LSHBands.begin(), LSHBands.end());
    auto last = std::unique(LSHBands.begin(), LSHBands.end());
    LSHBands.erase(last, LSHBands.end());
    
    return LSHBands;
  }

  uint32_t item_footprint() { return sizeof(uint32_t) * bands * (rows + 1); }
};
