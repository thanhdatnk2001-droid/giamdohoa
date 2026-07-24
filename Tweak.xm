#import <substrate.h>
#import <mach-o/dyld.h>

// --- PHẦN 1: KHAI BÁO CÁC HÀM GỐC CỦA UNITY ---
void (*old_set_vSyncCount)(int value);
void (*old_set_targetFrameRate)(int value);
// void (*old_set_shadows)(int value); // Mở lại dòng này nếu sau này bạn tìm được offset shadow

// --- PHẦN 2: VIẾT LOGIC GIẢM ĐỒ HỌA ---
// 1. Ép tắt VSync (Đồng bộ khung hình) để giảm tải cực mạnh cho GPU
void new_set_vSyncCount(int value) {
    old_set_vSyncCount(0); // 0 = Tắt VSync hoàn toàn
}

// 2. Khóa FPS ở mức 60 (Hoặc đổi thành 30 nếu máy bạn rất dễ nóng)
void new_set_targetFrameRate(int value) {
    old_set_targetFrameRate(60); 
}

// 3. Tắt bóng mờ (Nếu sau này có offset)
// void new_set_shadows(int value) {
//     old_set_shadows(0); // 0 = Disable shadows
// }

// --- PHẦN 3: KÍCH HOẠT HOOK KHI GAME MỞ LÊN ---
%ctor {
    // Lấy địa chỉ bộ nhớ ngẫu nhiên của iOS (ASLR slide)
    long slide = _dyld_get_image_vmaddr_slide(0);
    
    // ĐÂY LÀ OFFSET CHÍNH XÁC BẠN VỪA TÌM ĐƯỢC TRONG DUMP.CS:
    long offset_vSync = 0x6B881CC; 
    
    // Điền thêm các Offset khác vào đây nếu bạn tìm thấy trong tương lai:
    long offset_fps = 0x000000; // Thay 0x000000 bằng offset set_targetFrameRate của bạn
    // long offset_shadows = 0x000000; 
    
    // Thực hiện đánh tráo hàm VSync của game bằng hàm tắt VSync của chúng ta
    MSHookFunction((void*)(slide + offset_vSync), (void*)new_set_vSyncCount, (void**)&old_set_vSyncCount);
    
    // Nếu bạn đã tìm được offset FPS, hãy xóa 2 dấu gạch chéo // ở dòng dưới đi để kích hoạt:
    // MSHookFunction((void*)(slide + offset_fps), (void*)new_set_targetFrameRate, (void**)&old_set_targetFrameRate);
}
