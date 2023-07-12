#include <iostream>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <queue>
using namespace std;

std::mutex mtx;
std::condition_variable cv;
std::queue<int> buffer;

const int BUFFER_SIZE = 10;
const int NUM_ITEMS = 20;

void producer() {
    for (int i = 0; i < NUM_ITEMS; ++i) {
        std::this_thread::sleep_for(std::chrono::milliseconds(500));

        std::unique_lock<std::mutex> lock(mtx);
        cv.wait(lock, []{ return buffer.size() < BUFFER_SIZE; });

        buffer.push(i);
        std::cout << "Produced: " << i << std::endl;

        cv.notify_all();
    }
}

void consumer() {
    for (int i = 0; i < NUM_ITEMS; ++i) {
        std::this_thread::sleep_for(std::chrono::milliseconds(1000));

        std::unique_lock<std::mutex> lock(mtx);
        cv.wait(lock, []{ return !buffer.empty(); });

        int item = buffer.front();
        buffer.pop();
        std::cout << "Consumed: " << item << std::endl;

        cv.notify_all();
    }
}

int main() {
    std::thread producerThread(producer);
    std::thread consumerThread(consumer);

    producerThread.join();
    consumerThread.join();

    return 0;
}
