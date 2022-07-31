; RUN: %opt -S --passes="multiple-func-merging,default<Oz>" -func-merging-explore 1 -o %t.mfm.ll %s
; RUN: %opt -S --passes="func-merging,default<Oz>" -func-merging-explore 1 -o %t.fm.ll %s
; RUN: %llc --filetype=obj %t.mfm.ll -o %t.mfm.o
; RUN: %llc --filetype=obj %t.fm.ll -o %t.fm.o
; RUN: %strip %t.mfm.o
; RUN: %strip %t.fm.o
; RUN: [[ $(stat -c%%s %t.mfm.o) -le $(stat -c%%s %t.fm.o) ]]

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @susan_principle(i8* %0, i32* %1, i8* %2, i32 %3, i32 %4, i32 %5) #0 {
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca i32*, align 8
  %10 = alloca i8*, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i8*, align 8
  %18 = alloca i8*, align 8
  store i8* %0, i8** %8, align 8
  store i32* %1, i32** %9, align 8
  store i8* %2, i8** %10, align 8
  store i32 %3, i32* %11, align 4
  store i32 %4, i32* %12, align 4
  store i32 %5, i32* %13, align 4
  %19 = load i32*, i32** %9, align 8
  %20 = bitcast i32* %19 to i8*
  %21 = load i32, i32* %12, align 4
  %22 = load i32, i32* %13, align 4
  %23 = mul nsw i32 %21, %22
  %24 = sext i32 %23 to i64
  %25 = mul i64 %24, 4
  call void @llvm.memset.p0i8.i64(i8* align 4 %20, i8 0, i64 %25, i1 false)
  store i32 3, i32* %14, align 4
  br label %26

26:                                               ; preds = %538, %6
  %27 = load i32, i32* %14, align 4
  %28 = load i32, i32* %13, align 4
  %29 = sub nsw i32 %28, 3
  %30 = icmp slt i32 %27, %29
  br i1 %30, label %31, label %541

31:                                               ; preds = %26
  store i32 3, i32* %15, align 4
  br label %32

32:                                               ; preds = %534, %31
  %33 = load i32, i32* %15, align 4
  %34 = load i32, i32* %12, align 4
  %35 = sub nsw i32 %34, 3
  %36 = icmp slt i32 %33, %35
  br i1 %36, label %37, label %537

37:                                               ; preds = %32
  store i32 100, i32* %16, align 4
  %38 = load i8*, i8** %8, align 8
  %39 = load i32, i32* %14, align 4
  %40 = sub nsw i32 %39, 3
  %41 = load i32, i32* %12, align 4
  %42 = mul nsw i32 %40, %41
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds i8, i8* %38, i64 %43
  %45 = load i32, i32* %15, align 4
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds i8, i8* %44, i64 %46
  %48 = getelementptr inbounds i8, i8* %47, i64 -1
  store i8* %48, i8** %17, align 8
  %49 = load i8*, i8** %10, align 8
  %50 = load i8*, i8** %8, align 8
  %51 = load i32, i32* %14, align 4
  %52 = load i32, i32* %12, align 4
  %53 = mul nsw i32 %51, %52
  %54 = load i32, i32* %15, align 4
  %55 = add nsw i32 %53, %54
  %56 = sext i32 %55 to i64
  %57 = getelementptr inbounds i8, i8* %50, i64 %56
  %58 = load i8, i8* %57, align 1
  %59 = zext i8 %58 to i32
  %60 = sext i32 %59 to i64
  %61 = getelementptr inbounds i8, i8* %49, i64 %60
  store i8* %61, i8** %18, align 8
  %62 = load i8*, i8** %18, align 8
  %63 = load i8*, i8** %17, align 8
  %64 = getelementptr inbounds i8, i8* %63, i32 1
  store i8* %64, i8** %17, align 8
  %65 = load i8, i8* %63, align 1
  %66 = zext i8 %65 to i32
  %67 = sext i32 %66 to i64
  %68 = sub i64 0, %67
  %69 = getelementptr inbounds i8, i8* %62, i64 %68
  %70 = load i8, i8* %69, align 1
  %71 = zext i8 %70 to i32
  %72 = load i32, i32* %16, align 4
  %73 = add nsw i32 %72, %71
  store i32 %73, i32* %16, align 4
  %74 = load i8*, i8** %18, align 8
  %75 = load i8*, i8** %17, align 8
  %76 = getelementptr inbounds i8, i8* %75, i32 1
  store i8* %76, i8** %17, align 8
  %77 = load i8, i8* %75, align 1
  %78 = zext i8 %77 to i32
  %79 = sext i32 %78 to i64
  %80 = sub i64 0, %79
  %81 = getelementptr inbounds i8, i8* %74, i64 %80
  %82 = load i8, i8* %81, align 1
  %83 = zext i8 %82 to i32
  %84 = load i32, i32* %16, align 4
  %85 = add nsw i32 %84, %83
  store i32 %85, i32* %16, align 4
  %86 = load i8*, i8** %18, align 8
  %87 = load i8*, i8** %17, align 8
  %88 = load i8, i8* %87, align 1
  %89 = zext i8 %88 to i32
  %90 = sext i32 %89 to i64
  %91 = sub i64 0, %90
  %92 = getelementptr inbounds i8, i8* %86, i64 %91
  %93 = load i8, i8* %92, align 1
  %94 = zext i8 %93 to i32
  %95 = load i32, i32* %16, align 4
  %96 = add nsw i32 %95, %94
  store i32 %96, i32* %16, align 4
  %97 = load i32, i32* %12, align 4
  %98 = sub nsw i32 %97, 3
  %99 = load i8*, i8** %17, align 8
  %100 = sext i32 %98 to i64
  %101 = getelementptr inbounds i8, i8* %99, i64 %100
  store i8* %101, i8** %17, align 8
  %102 = load i8*, i8** %18, align 8
  %103 = load i8*, i8** %17, align 8
  %104 = getelementptr inbounds i8, i8* %103, i32 1
  store i8* %104, i8** %17, align 8
  %105 = load i8, i8* %103, align 1
  %106 = zext i8 %105 to i32
  %107 = sext i32 %106 to i64
  %108 = sub i64 0, %107
  %109 = getelementptr inbounds i8, i8* %102, i64 %108
  %110 = load i8, i8* %109, align 1
  %111 = zext i8 %110 to i32
  %112 = load i32, i32* %16, align 4
  %113 = add nsw i32 %112, %111
  store i32 %113, i32* %16, align 4
  %114 = load i8*, i8** %18, align 8
  %115 = load i8*, i8** %17, align 8
  %116 = getelementptr inbounds i8, i8* %115, i32 1
  store i8* %116, i8** %17, align 8
  %117 = load i8, i8* %115, align 1
  %118 = zext i8 %117 to i32
  %119 = sext i32 %118 to i64
  %120 = sub i64 0, %119
  %121 = getelementptr inbounds i8, i8* %114, i64 %120
  %122 = load i8, i8* %121, align 1
  %123 = zext i8 %122 to i32
  %124 = load i32, i32* %16, align 4
  %125 = add nsw i32 %124, %123
  store i32 %125, i32* %16, align 4
  %126 = load i8*, i8** %18, align 8
  %127 = load i8*, i8** %17, align 8
  %128 = getelementptr inbounds i8, i8* %127, i32 1
  store i8* %128, i8** %17, align 8
  %129 = load i8, i8* %127, align 1
  %130 = zext i8 %129 to i32
  %131 = sext i32 %130 to i64
  %132 = sub i64 0, %131
  %133 = getelementptr inbounds i8, i8* %126, i64 %132
  %134 = load i8, i8* %133, align 1
  %135 = zext i8 %134 to i32
  %136 = load i32, i32* %16, align 4
  %137 = add nsw i32 %136, %135
  store i32 %137, i32* %16, align 4
  %138 = load i8*, i8** %18, align 8
  %139 = load i8*, i8** %17, align 8
  %140 = getelementptr inbounds i8, i8* %139, i32 1
  store i8* %140, i8** %17, align 8
  %141 = load i8, i8* %139, align 1
  %142 = zext i8 %141 to i32
  %143 = sext i32 %142 to i64
  %144 = sub i64 0, %143
  %145 = getelementptr inbounds i8, i8* %138, i64 %144
  %146 = load i8, i8* %145, align 1
  %147 = zext i8 %146 to i32
  %148 = load i32, i32* %16, align 4
  %149 = add nsw i32 %148, %147
  store i32 %149, i32* %16, align 4
  %150 = load i8*, i8** %18, align 8
  %151 = load i8*, i8** %17, align 8
  %152 = load i8, i8* %151, align 1
  %153 = zext i8 %152 to i32
  %154 = sext i32 %153 to i64
  %155 = sub i64 0, %154
  %156 = getelementptr inbounds i8, i8* %150, i64 %155
  %157 = load i8, i8* %156, align 1
  %158 = zext i8 %157 to i32
  %159 = load i32, i32* %16, align 4
  %160 = add nsw i32 %159, %158
  store i32 %160, i32* %16, align 4
  %161 = load i32, i32* %12, align 4
  %162 = sub nsw i32 %161, 5
  %163 = load i8*, i8** %17, align 8
  %164 = sext i32 %162 to i64
  %165 = getelementptr inbounds i8, i8* %163, i64 %164
  store i8* %165, i8** %17, align 8
  %166 = load i8*, i8** %18, align 8
  %167 = load i8*, i8** %17, align 8
  %168 = getelementptr inbounds i8, i8* %167, i32 1
  store i8* %168, i8** %17, align 8
  %169 = load i8, i8* %167, align 1
  %170 = zext i8 %169 to i32
  %171 = sext i32 %170 to i64
  %172 = sub i64 0, %171
  %173 = getelementptr inbounds i8, i8* %166, i64 %172
  %174 = load i8, i8* %173, align 1
  %175 = zext i8 %174 to i32
  %176 = load i32, i32* %16, align 4
  %177 = add nsw i32 %176, %175
  store i32 %177, i32* %16, align 4
  %178 = load i8*, i8** %18, align 8
  %179 = load i8*, i8** %17, align 8
  %180 = getelementptr inbounds i8, i8* %179, i32 1
  store i8* %180, i8** %17, align 8
  %181 = load i8, i8* %179, align 1
  %182 = zext i8 %181 to i32
  %183 = sext i32 %182 to i64
  %184 = sub i64 0, %183
  %185 = getelementptr inbounds i8, i8* %178, i64 %184
  %186 = load i8, i8* %185, align 1
  %187 = zext i8 %186 to i32
  %188 = load i32, i32* %16, align 4
  %189 = add nsw i32 %188, %187
  store i32 %189, i32* %16, align 4
  %190 = load i8*, i8** %18, align 8
  %191 = load i8*, i8** %17, align 8
  %192 = getelementptr inbounds i8, i8* %191, i32 1
  store i8* %192, i8** %17, align 8
  %193 = load i8, i8* %191, align 1
  %194 = zext i8 %193 to i32
  %195 = sext i32 %194 to i64
  %196 = sub i64 0, %195
  %197 = getelementptr inbounds i8, i8* %190, i64 %196
  %198 = load i8, i8* %197, align 1
  %199 = zext i8 %198 to i32
  %200 = load i32, i32* %16, align 4
  %201 = add nsw i32 %200, %199
  store i32 %201, i32* %16, align 4
  %202 = load i8*, i8** %18, align 8
  %203 = load i8*, i8** %17, align 8
  %204 = getelementptr inbounds i8, i8* %203, i32 1
  store i8* %204, i8** %17, align 8
  %205 = load i8, i8* %203, align 1
  %206 = zext i8 %205 to i32
  %207 = sext i32 %206 to i64
  %208 = sub i64 0, %207
  %209 = getelementptr inbounds i8, i8* %202, i64 %208
  %210 = load i8, i8* %209, align 1
  %211 = zext i8 %210 to i32
  %212 = load i32, i32* %16, align 4
  %213 = add nsw i32 %212, %211
  store i32 %213, i32* %16, align 4
  %214 = load i8*, i8** %18, align 8
  %215 = load i8*, i8** %17, align 8
  %216 = getelementptr inbounds i8, i8* %215, i32 1
  store i8* %216, i8** %17, align 8
  %217 = load i8, i8* %215, align 1
  %218 = zext i8 %217 to i32
  %219 = sext i32 %218 to i64
  %220 = sub i64 0, %219
  %221 = getelementptr inbounds i8, i8* %214, i64 %220
  %222 = load i8, i8* %221, align 1
  %223 = zext i8 %222 to i32
  %224 = load i32, i32* %16, align 4
  %225 = add nsw i32 %224, %223
  store i32 %225, i32* %16, align 4
  %226 = load i8*, i8** %18, align 8
  %227 = load i8*, i8** %17, align 8
  %228 = getelementptr inbounds i8, i8* %227, i32 1
  store i8* %228, i8** %17, align 8
  %229 = load i8, i8* %227, align 1
  %230 = zext i8 %229 to i32
  %231 = sext i32 %230 to i64
  %232 = sub i64 0, %231
  %233 = getelementptr inbounds i8, i8* %226, i64 %232
  %234 = load i8, i8* %233, align 1
  %235 = zext i8 %234 to i32
  %236 = load i32, i32* %16, align 4
  %237 = add nsw i32 %236, %235
  store i32 %237, i32* %16, align 4
  %238 = load i8*, i8** %18, align 8
  %239 = load i8*, i8** %17, align 8
  %240 = load i8, i8* %239, align 1
  %241 = zext i8 %240 to i32
  %242 = sext i32 %241 to i64
  %243 = sub i64 0, %242
  %244 = getelementptr inbounds i8, i8* %238, i64 %243
  %245 = load i8, i8* %244, align 1
  %246 = zext i8 %245 to i32
  %247 = load i32, i32* %16, align 4
  %248 = add nsw i32 %247, %246
  store i32 %248, i32* %16, align 4
  %249 = load i32, i32* %12, align 4
  %250 = sub nsw i32 %249, 6
  %251 = load i8*, i8** %17, align 8
  %252 = sext i32 %250 to i64
  %253 = getelementptr inbounds i8, i8* %251, i64 %252
  store i8* %253, i8** %17, align 8
  %254 = load i8*, i8** %18, align 8
  %255 = load i8*, i8** %17, align 8
  %256 = getelementptr inbounds i8, i8* %255, i32 1
  store i8* %256, i8** %17, align 8
  %257 = load i8, i8* %255, align 1
  %258 = zext i8 %257 to i32
  %259 = sext i32 %258 to i64
  %260 = sub i64 0, %259
  %261 = getelementptr inbounds i8, i8* %254, i64 %260
  %262 = load i8, i8* %261, align 1
  %263 = zext i8 %262 to i32
  %264 = load i32, i32* %16, align 4
  %265 = add nsw i32 %264, %263
  store i32 %265, i32* %16, align 4
  %266 = load i8*, i8** %18, align 8
  %267 = load i8*, i8** %17, align 8
  %268 = getelementptr inbounds i8, i8* %267, i32 1
  store i8* %268, i8** %17, align 8
  %269 = load i8, i8* %267, align 1
  %270 = zext i8 %269 to i32
  %271 = sext i32 %270 to i64
  %272 = sub i64 0, %271
  %273 = getelementptr inbounds i8, i8* %266, i64 %272
  %274 = load i8, i8* %273, align 1
  %275 = zext i8 %274 to i32
  %276 = load i32, i32* %16, align 4
  %277 = add nsw i32 %276, %275
  store i32 %277, i32* %16, align 4
  %278 = load i8*, i8** %18, align 8
  %279 = load i8*, i8** %17, align 8
  %280 = load i8, i8* %279, align 1
  %281 = zext i8 %280 to i32
  %282 = sext i32 %281 to i64
  %283 = sub i64 0, %282
  %284 = getelementptr inbounds i8, i8* %278, i64 %283
  %285 = load i8, i8* %284, align 1
  %286 = zext i8 %285 to i32
  %287 = load i32, i32* %16, align 4
  %288 = add nsw i32 %287, %286
  store i32 %288, i32* %16, align 4
  %289 = load i8*, i8** %17, align 8
  %290 = getelementptr inbounds i8, i8* %289, i64 2
  store i8* %290, i8** %17, align 8
  %291 = load i8*, i8** %18, align 8
  %292 = load i8*, i8** %17, align 8
  %293 = getelementptr inbounds i8, i8* %292, i32 1
  store i8* %293, i8** %17, align 8
  %294 = load i8, i8* %292, align 1
  %295 = zext i8 %294 to i32
  %296 = sext i32 %295 to i64
  %297 = sub i64 0, %296
  %298 = getelementptr inbounds i8, i8* %291, i64 %297
  %299 = load i8, i8* %298, align 1
  %300 = zext i8 %299 to i32
  %301 = load i32, i32* %16, align 4
  %302 = add nsw i32 %301, %300
  store i32 %302, i32* %16, align 4
  %303 = load i8*, i8** %18, align 8
  %304 = load i8*, i8** %17, align 8
  %305 = getelementptr inbounds i8, i8* %304, i32 1
  store i8* %305, i8** %17, align 8
  %306 = load i8, i8* %304, align 1
  %307 = zext i8 %306 to i32
  %308 = sext i32 %307 to i64
  %309 = sub i64 0, %308
  %310 = getelementptr inbounds i8, i8* %303, i64 %309
  %311 = load i8, i8* %310, align 1
  %312 = zext i8 %311 to i32
  %313 = load i32, i32* %16, align 4
  %314 = add nsw i32 %313, %312
  store i32 %314, i32* %16, align 4
  %315 = load i8*, i8** %18, align 8
  %316 = load i8*, i8** %17, align 8
  %317 = load i8, i8* %316, align 1
  %318 = zext i8 %317 to i32
  %319 = sext i32 %318 to i64
  %320 = sub i64 0, %319
  %321 = getelementptr inbounds i8, i8* %315, i64 %320
  %322 = load i8, i8* %321, align 1
  %323 = zext i8 %322 to i32
  %324 = load i32, i32* %16, align 4
  %325 = add nsw i32 %324, %323
  store i32 %325, i32* %16, align 4
  %326 = load i32, i32* %12, align 4
  %327 = sub nsw i32 %326, 6
  %328 = load i8*, i8** %17, align 8
  %329 = sext i32 %327 to i64
  %330 = getelementptr inbounds i8, i8* %328, i64 %329
  store i8* %330, i8** %17, align 8
  %331 = load i8*, i8** %18, align 8
  %332 = load i8*, i8** %17, align 8
  %333 = getelementptr inbounds i8, i8* %332, i32 1
  store i8* %333, i8** %17, align 8
  %334 = load i8, i8* %332, align 1
  %335 = zext i8 %334 to i32
  %336 = sext i32 %335 to i64
  %337 = sub i64 0, %336
  %338 = getelementptr inbounds i8, i8* %331, i64 %337
  %339 = load i8, i8* %338, align 1
  %340 = zext i8 %339 to i32
  %341 = load i32, i32* %16, align 4
  %342 = add nsw i32 %341, %340
  store i32 %342, i32* %16, align 4
  %343 = load i8*, i8** %18, align 8
  %344 = load i8*, i8** %17, align 8
  %345 = getelementptr inbounds i8, i8* %344, i32 1
  store i8* %345, i8** %17, align 8
  %346 = load i8, i8* %344, align 1
  %347 = zext i8 %346 to i32
  %348 = sext i32 %347 to i64
  %349 = sub i64 0, %348
  %350 = getelementptr inbounds i8, i8* %343, i64 %349
  %351 = load i8, i8* %350, align 1
  %352 = zext i8 %351 to i32
  %353 = load i32, i32* %16, align 4
  %354 = add nsw i32 %353, %352
  store i32 %354, i32* %16, align 4
  %355 = load i8*, i8** %18, align 8
  %356 = load i8*, i8** %17, align 8
  %357 = getelementptr inbounds i8, i8* %356, i32 1
  store i8* %357, i8** %17, align 8
  %358 = load i8, i8* %356, align 1
  %359 = zext i8 %358 to i32
  %360 = sext i32 %359 to i64
  %361 = sub i64 0, %360
  %362 = getelementptr inbounds i8, i8* %355, i64 %361
  %363 = load i8, i8* %362, align 1
  %364 = zext i8 %363 to i32
  %365 = load i32, i32* %16, align 4
  %366 = add nsw i32 %365, %364
  store i32 %366, i32* %16, align 4
  %367 = load i8*, i8** %18, align 8
  %368 = load i8*, i8** %17, align 8
  %369 = getelementptr inbounds i8, i8* %368, i32 1
  store i8* %369, i8** %17, align 8
  %370 = load i8, i8* %368, align 1
  %371 = zext i8 %370 to i32
  %372 = sext i32 %371 to i64
  %373 = sub i64 0, %372
  %374 = getelementptr inbounds i8, i8* %367, i64 %373
  %375 = load i8, i8* %374, align 1
  %376 = zext i8 %375 to i32
  %377 = load i32, i32* %16, align 4
  %378 = add nsw i32 %377, %376
  store i32 %378, i32* %16, align 4
  %379 = load i8*, i8** %18, align 8
  %380 = load i8*, i8** %17, align 8
  %381 = getelementptr inbounds i8, i8* %380, i32 1
  store i8* %381, i8** %17, align 8
  %382 = load i8, i8* %380, align 1
  %383 = zext i8 %382 to i32
  %384 = sext i32 %383 to i64
  %385 = sub i64 0, %384
  %386 = getelementptr inbounds i8, i8* %379, i64 %385
  %387 = load i8, i8* %386, align 1
  %388 = zext i8 %387 to i32
  %389 = load i32, i32* %16, align 4
  %390 = add nsw i32 %389, %388
  store i32 %390, i32* %16, align 4
  %391 = load i8*, i8** %18, align 8
  %392 = load i8*, i8** %17, align 8
  %393 = getelementptr inbounds i8, i8* %392, i32 1
  store i8* %393, i8** %17, align 8
  %394 = load i8, i8* %392, align 1
  %395 = zext i8 %394 to i32
  %396 = sext i32 %395 to i64
  %397 = sub i64 0, %396
  %398 = getelementptr inbounds i8, i8* %391, i64 %397
  %399 = load i8, i8* %398, align 1
  %400 = zext i8 %399 to i32
  %401 = load i32, i32* %16, align 4
  %402 = add nsw i32 %401, %400
  store i32 %402, i32* %16, align 4
  %403 = load i8*, i8** %18, align 8
  %404 = load i8*, i8** %17, align 8
  %405 = load i8, i8* %404, align 1
  %406 = zext i8 %405 to i32
  %407 = sext i32 %406 to i64
  %408 = sub i64 0, %407
  %409 = getelementptr inbounds i8, i8* %403, i64 %408
  %410 = load i8, i8* %409, align 1
  %411 = zext i8 %410 to i32
  %412 = load i32, i32* %16, align 4
  %413 = add nsw i32 %412, %411
  store i32 %413, i32* %16, align 4
  %414 = load i32, i32* %12, align 4
  %415 = sub nsw i32 %414, 5
  %416 = load i8*, i8** %17, align 8
  %417 = sext i32 %415 to i64
  %418 = getelementptr inbounds i8, i8* %416, i64 %417
  store i8* %418, i8** %17, align 8
  %419 = load i8*, i8** %18, align 8
  %420 = load i8*, i8** %17, align 8
  %421 = getelementptr inbounds i8, i8* %420, i32 1
  store i8* %421, i8** %17, align 8
  %422 = load i8, i8* %420, align 1
  %423 = zext i8 %422 to i32
  %424 = sext i32 %423 to i64
  %425 = sub i64 0, %424
  %426 = getelementptr inbounds i8, i8* %419, i64 %425
  %427 = load i8, i8* %426, align 1
  %428 = zext i8 %427 to i32
  %429 = load i32, i32* %16, align 4
  %430 = add nsw i32 %429, %428
  store i32 %430, i32* %16, align 4
  %431 = load i8*, i8** %18, align 8
  %432 = load i8*, i8** %17, align 8
  %433 = getelementptr inbounds i8, i8* %432, i32 1
  store i8* %433, i8** %17, align 8
  %434 = load i8, i8* %432, align 1
  %435 = zext i8 %434 to i32
  %436 = sext i32 %435 to i64
  %437 = sub i64 0, %436
  %438 = getelementptr inbounds i8, i8* %431, i64 %437
  %439 = load i8, i8* %438, align 1
  %440 = zext i8 %439 to i32
  %441 = load i32, i32* %16, align 4
  %442 = add nsw i32 %441, %440
  store i32 %442, i32* %16, align 4
  %443 = load i8*, i8** %18, align 8
  %444 = load i8*, i8** %17, align 8
  %445 = getelementptr inbounds i8, i8* %444, i32 1
  store i8* %445, i8** %17, align 8
  %446 = load i8, i8* %444, align 1
  %447 = zext i8 %446 to i32
  %448 = sext i32 %447 to i64
  %449 = sub i64 0, %448
  %450 = getelementptr inbounds i8, i8* %443, i64 %449
  %451 = load i8, i8* %450, align 1
  %452 = zext i8 %451 to i32
  %453 = load i32, i32* %16, align 4
  %454 = add nsw i32 %453, %452
  store i32 %454, i32* %16, align 4
  %455 = load i8*, i8** %18, align 8
  %456 = load i8*, i8** %17, align 8
  %457 = getelementptr inbounds i8, i8* %456, i32 1
  store i8* %457, i8** %17, align 8
  %458 = load i8, i8* %456, align 1
  %459 = zext i8 %458 to i32
  %460 = sext i32 %459 to i64
  %461 = sub i64 0, %460
  %462 = getelementptr inbounds i8, i8* %455, i64 %461
  %463 = load i8, i8* %462, align 1
  %464 = zext i8 %463 to i32
  %465 = load i32, i32* %16, align 4
  %466 = add nsw i32 %465, %464
  store i32 %466, i32* %16, align 4
  %467 = load i8*, i8** %18, align 8
  %468 = load i8*, i8** %17, align 8
  %469 = load i8, i8* %468, align 1
  %470 = zext i8 %469 to i32
  %471 = sext i32 %470 to i64
  %472 = sub i64 0, %471
  %473 = getelementptr inbounds i8, i8* %467, i64 %472
  %474 = load i8, i8* %473, align 1
  %475 = zext i8 %474 to i32
  %476 = load i32, i32* %16, align 4
  %477 = add nsw i32 %476, %475
  store i32 %477, i32* %16, align 4
  %478 = load i32, i32* %12, align 4
  %479 = sub nsw i32 %478, 3
  %480 = load i8*, i8** %17, align 8
  %481 = sext i32 %479 to i64
  %482 = getelementptr inbounds i8, i8* %480, i64 %481
  store i8* %482, i8** %17, align 8
  %483 = load i8*, i8** %18, align 8
  %484 = load i8*, i8** %17, align 8
  %485 = getelementptr inbounds i8, i8* %484, i32 1
  store i8* %485, i8** %17, align 8
  %486 = load i8, i8* %484, align 1
  %487 = zext i8 %486 to i32
  %488 = sext i32 %487 to i64
  %489 = sub i64 0, %488
  %490 = getelementptr inbounds i8, i8* %483, i64 %489
  %491 = load i8, i8* %490, align 1
  %492 = zext i8 %491 to i32
  %493 = load i32, i32* %16, align 4
  %494 = add nsw i32 %493, %492
  store i32 %494, i32* %16, align 4
  %495 = load i8*, i8** %18, align 8
  %496 = load i8*, i8** %17, align 8
  %497 = getelementptr inbounds i8, i8* %496, i32 1
  store i8* %497, i8** %17, align 8
  %498 = load i8, i8* %496, align 1
  %499 = zext i8 %498 to i32
  %500 = sext i32 %499 to i64
  %501 = sub i64 0, %500
  %502 = getelementptr inbounds i8, i8* %495, i64 %501
  %503 = load i8, i8* %502, align 1
  %504 = zext i8 %503 to i32
  %505 = load i32, i32* %16, align 4
  %506 = add nsw i32 %505, %504
  store i32 %506, i32* %16, align 4
  %507 = load i8*, i8** %18, align 8
  %508 = load i8*, i8** %17, align 8
  %509 = load i8, i8* %508, align 1
  %510 = zext i8 %509 to i32
  %511 = sext i32 %510 to i64
  %512 = sub i64 0, %511
  %513 = getelementptr inbounds i8, i8* %507, i64 %512
  %514 = load i8, i8* %513, align 1
  %515 = zext i8 %514 to i32
  %516 = load i32, i32* %16, align 4
  %517 = add nsw i32 %516, %515
  store i32 %517, i32* %16, align 4
  %518 = load i32, i32* %16, align 4
  %519 = load i32, i32* %11, align 4
  %520 = icmp sle i32 %518, %519
  br i1 %520, label %521, label %533

521:                                              ; preds = %37
  %522 = load i32, i32* %11, align 4
  %523 = load i32, i32* %16, align 4
  %524 = sub nsw i32 %522, %523
  %525 = load i32*, i32** %9, align 8
  %526 = load i32, i32* %14, align 4
  %527 = load i32, i32* %12, align 4
  %528 = mul nsw i32 %526, %527
  %529 = load i32, i32* %15, align 4
  %530 = add nsw i32 %528, %529
  %531 = sext i32 %530 to i64
  %532 = getelementptr inbounds i32, i32* %525, i64 %531
  store i32 %524, i32* %532, align 4
  br label %533

533:                                              ; preds = %521, %37
  br label %534

534:                                              ; preds = %533
  %535 = load i32, i32* %15, align 4
  %536 = add nsw i32 %535, 1
  store i32 %536, i32* %15, align 4
  br label %32, !llvm.loop !7

537:                                              ; preds = %32
  br label %538

538:                                              ; preds = %537
  %539 = load i32, i32* %14, align 4
  %540 = add nsw i32 %539, 1
  store i32 %540, i32* %14, align 4
  br label %26, !llvm.loop !9

541:                                              ; preds = %26
  %542 = load i32, i32* %7, align 4
  ret i32 %542
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone ssp uwtable
define i32 @susan_principle_small(i8* %0, i32* %1, i8* %2, i32 %3, i32 %4, i32 %5) #0 {
  %7 = alloca i32, align 4
  %8 = alloca i8*, align 8
  %9 = alloca i32*, align 8
  %10 = alloca i8*, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i8*, align 8
  %18 = alloca i8*, align 8
  store i8* %0, i8** %8, align 8
  store i32* %1, i32** %9, align 8
  store i8* %2, i8** %10, align 8
  store i32 %3, i32* %11, align 4
  store i32 %4, i32* %12, align 4
  store i32 %5, i32* %13, align 4
  %19 = load i32*, i32** %9, align 8
  %20 = bitcast i32* %19 to i8*
  %21 = load i32, i32* %12, align 4
  %22 = load i32, i32* %13, align 4
  %23 = mul nsw i32 %21, %22
  %24 = sext i32 %23 to i64
  %25 = mul i64 %24, 4
  call void @llvm.memset.p0i8.i64(i8* align 4 %20, i8 0, i64 %25, i1 false)
  store i32 730, i32* %11, align 4
  store i32 1, i32* %14, align 4
  br label %26

26:                                               ; preds = %186, %6
  %27 = load i32, i32* %14, align 4
  %28 = load i32, i32* %13, align 4
  %29 = sub nsw i32 %28, 1
  %30 = icmp slt i32 %27, %29
  br i1 %30, label %31, label %189

31:                                               ; preds = %26
  store i32 1, i32* %15, align 4
  br label %32

32:                                               ; preds = %182, %31
  %33 = load i32, i32* %15, align 4
  %34 = load i32, i32* %12, align 4
  %35 = sub nsw i32 %34, 1
  %36 = icmp slt i32 %33, %35
  br i1 %36, label %37, label %185

37:                                               ; preds = %32
  store i32 100, i32* %16, align 4
  %38 = load i8*, i8** %8, align 8
  %39 = load i32, i32* %14, align 4
  %40 = sub nsw i32 %39, 1
  %41 = load i32, i32* %12, align 4
  %42 = mul nsw i32 %40, %41
  %43 = sext i32 %42 to i64
  %44 = getelementptr inbounds i8, i8* %38, i64 %43
  %45 = load i32, i32* %15, align 4
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds i8, i8* %44, i64 %46
  %48 = getelementptr inbounds i8, i8* %47, i64 -1
  store i8* %48, i8** %17, align 8
  %49 = load i8*, i8** %10, align 8
  %50 = load i8*, i8** %8, align 8
  %51 = load i32, i32* %14, align 4
  %52 = load i32, i32* %12, align 4
  %53 = mul nsw i32 %51, %52
  %54 = load i32, i32* %15, align 4
  %55 = add nsw i32 %53, %54
  %56 = sext i32 %55 to i64
  %57 = getelementptr inbounds i8, i8* %50, i64 %56
  %58 = load i8, i8* %57, align 1
  %59 = zext i8 %58 to i32
  %60 = sext i32 %59 to i64
  %61 = getelementptr inbounds i8, i8* %49, i64 %60
  store i8* %61, i8** %18, align 8
  %62 = load i8*, i8** %18, align 8
  %63 = load i8*, i8** %17, align 8
  %64 = getelementptr inbounds i8, i8* %63, i32 1
  store i8* %64, i8** %17, align 8
  %65 = load i8, i8* %63, align 1
  %66 = zext i8 %65 to i32
  %67 = sext i32 %66 to i64
  %68 = sub i64 0, %67
  %69 = getelementptr inbounds i8, i8* %62, i64 %68
  %70 = load i8, i8* %69, align 1
  %71 = zext i8 %70 to i32
  %72 = load i32, i32* %16, align 4
  %73 = add nsw i32 %72, %71
  store i32 %73, i32* %16, align 4
  %74 = load i8*, i8** %18, align 8
  %75 = load i8*, i8** %17, align 8
  %76 = getelementptr inbounds i8, i8* %75, i32 1
  store i8* %76, i8** %17, align 8
  %77 = load i8, i8* %75, align 1
  %78 = zext i8 %77 to i32
  %79 = sext i32 %78 to i64
  %80 = sub i64 0, %79
  %81 = getelementptr inbounds i8, i8* %74, i64 %80
  %82 = load i8, i8* %81, align 1
  %83 = zext i8 %82 to i32
  %84 = load i32, i32* %16, align 4
  %85 = add nsw i32 %84, %83
  store i32 %85, i32* %16, align 4
  %86 = load i8*, i8** %18, align 8
  %87 = load i8*, i8** %17, align 8
  %88 = load i8, i8* %87, align 1
  %89 = zext i8 %88 to i32
  %90 = sext i32 %89 to i64
  %91 = sub i64 0, %90
  %92 = getelementptr inbounds i8, i8* %86, i64 %91
  %93 = load i8, i8* %92, align 1
  %94 = zext i8 %93 to i32
  %95 = load i32, i32* %16, align 4
  %96 = add nsw i32 %95, %94
  store i32 %96, i32* %16, align 4
  %97 = load i32, i32* %12, align 4
  %98 = sub nsw i32 %97, 2
  %99 = load i8*, i8** %17, align 8
  %100 = sext i32 %98 to i64
  %101 = getelementptr inbounds i8, i8* %99, i64 %100
  store i8* %101, i8** %17, align 8
  %102 = load i8*, i8** %18, align 8
  %103 = load i8*, i8** %17, align 8
  %104 = load i8, i8* %103, align 1
  %105 = zext i8 %104 to i32
  %106 = sext i32 %105 to i64
  %107 = sub i64 0, %106
  %108 = getelementptr inbounds i8, i8* %102, i64 %107
  %109 = load i8, i8* %108, align 1
  %110 = zext i8 %109 to i32
  %111 = load i32, i32* %16, align 4
  %112 = add nsw i32 %111, %110
  store i32 %112, i32* %16, align 4
  %113 = load i8*, i8** %17, align 8
  %114 = getelementptr inbounds i8, i8* %113, i64 2
  store i8* %114, i8** %17, align 8
  %115 = load i8*, i8** %18, align 8
  %116 = load i8*, i8** %17, align 8
  %117 = load i8, i8* %116, align 1
  %118 = zext i8 %117 to i32
  %119 = sext i32 %118 to i64
  %120 = sub i64 0, %119
  %121 = getelementptr inbounds i8, i8* %115, i64 %120
  %122 = load i8, i8* %121, align 1
  %123 = zext i8 %122 to i32
  %124 = load i32, i32* %16, align 4
  %125 = add nsw i32 %124, %123
  store i32 %125, i32* %16, align 4
  %126 = load i32, i32* %12, align 4
  %127 = sub nsw i32 %126, 2
  %128 = load i8*, i8** %17, align 8
  %129 = sext i32 %127 to i64
  %130 = getelementptr inbounds i8, i8* %128, i64 %129
  store i8* %130, i8** %17, align 8
  %131 = load i8*, i8** %18, align 8
  %132 = load i8*, i8** %17, align 8
  %133 = getelementptr inbounds i8, i8* %132, i32 1
  store i8* %133, i8** %17, align 8
  %134 = load i8, i8* %132, align 1
  %135 = zext i8 %134 to i32
  %136 = sext i32 %135 to i64
  %137 = sub i64 0, %136
  %138 = getelementptr inbounds i8, i8* %131, i64 %137
  %139 = load i8, i8* %138, align 1
  %140 = zext i8 %139 to i32
  %141 = load i32, i32* %16, align 4
  %142 = add nsw i32 %141, %140
  store i32 %142, i32* %16, align 4
  %143 = load i8*, i8** %18, align 8
  %144 = load i8*, i8** %17, align 8
  %145 = getelementptr inbounds i8, i8* %144, i32 1
  store i8* %145, i8** %17, align 8
  %146 = load i8, i8* %144, align 1
  %147 = zext i8 %146 to i32
  %148 = sext i32 %147 to i64
  %149 = sub i64 0, %148
  %150 = getelementptr inbounds i8, i8* %143, i64 %149
  %151 = load i8, i8* %150, align 1
  %152 = zext i8 %151 to i32
  %153 = load i32, i32* %16, align 4
  %154 = add nsw i32 %153, %152
  store i32 %154, i32* %16, align 4
  %155 = load i8*, i8** %18, align 8
  %156 = load i8*, i8** %17, align 8
  %157 = load i8, i8* %156, align 1
  %158 = zext i8 %157 to i32
  %159 = sext i32 %158 to i64
  %160 = sub i64 0, %159
  %161 = getelementptr inbounds i8, i8* %155, i64 %160
  %162 = load i8, i8* %161, align 1
  %163 = zext i8 %162 to i32
  %164 = load i32, i32* %16, align 4
  %165 = add nsw i32 %164, %163
  store i32 %165, i32* %16, align 4
  %166 = load i32, i32* %16, align 4
  %167 = load i32, i32* %11, align 4
  %168 = icmp sle i32 %166, %167
  br i1 %168, label %169, label %181

169:                                              ; preds = %37
  %170 = load i32, i32* %11, align 4
  %171 = load i32, i32* %16, align 4
  %172 = sub nsw i32 %170, %171
  %173 = load i32*, i32** %9, align 8
  %174 = load i32, i32* %14, align 4
  %175 = load i32, i32* %12, align 4
  %176 = mul nsw i32 %174, %175
  %177 = load i32, i32* %15, align 4
  %178 = add nsw i32 %176, %177
  %179 = sext i32 %178 to i64
  %180 = getelementptr inbounds i32, i32* %173, i64 %179
  store i32 %172, i32* %180, align 4
  br label %181

181:                                              ; preds = %169, %37
  br label %182

182:                                              ; preds = %181
  %183 = load i32, i32* %15, align 4
  %184 = add nsw i32 %183, 1
  store i32 %184, i32* %15, align 4
  br label %32, !llvm.loop !10

185:                                              ; preds = %32
  br label %186

186:                                              ; preds = %185
  %187 = load i32, i32* %14, align 4
  %188 = add nsw i32 %187, 1
  store i32 %188, i32* %14, align 4
  br label %26, !llvm.loop !11

189:                                              ; preds = %26
  %190 = load i32, i32* %7, align 4
  ret i32 %190
}

attributes #0 = { noinline nounwind optnone ssp uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }

!llvm.ident = !{!0}
!llvm.module.flags = !{!1, !2, !3, !4, !5, !6}

!0 = !{!"clang version 13.0.0 (https://github.com/llvm/llvm-project/ 24c8eaec9467b2aaf70b0db33a4e4dd415139a50)"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{i32 1, !"ThinLTO", i32 0}
!6 = !{i32 1, !"EnableSplitLTOUnit", i32 1}
!7 = distinct !{!7, !8}
!8 = !{!"llvm.loop.mustprogress"}
!9 = distinct !{!9, !8}
!10 = distinct !{!10, !8}
!11 = distinct !{!11, !8}
