//
//  XBPageTitleView.swift
//  DouYus
//
//  Created by 冼 on 2018/10/6.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit
//配合PageTitleViewDelegate代理方法进行实现
protocol PageTitleViewDelegate : class {
    
    func pageTitleView(titleView : XBPageTitleView, selectedIndex index: Int)

}


class XBPageTitleView: UIView {
    // 代理协议
    weak var delegate : PageTitleViewDelegate?
    
    //标题
    private var titles : [String]
    
    //懒加载，如果这个lazy修饰的变量没值，就会执行闭包中的东西，不是每次都执行
    //要注意的一点是：添加到父视图的操作，千万不要写到懒加载里面，会出问题的！
    private lazy var option : XBPageOptions = {
        let option = XBPageOptions()
        return option
    }()
    
    
    //滚动 View
    private lazy var scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        //用于控制是否启用滚动到顶部的手势.滚动到顶部的手势是点击状态栏
        scrollView.scrollsToTop = false
        //用于控制滚动视图是否跳过内容边缘并返回。
        scrollView.bounces = false
        return scrollView
        
    }()
    // 创建一个 label 数组
    private lazy var titleLabs : [UILabel] = [UILabel]()
    // 索引
    private var currentIndex : Int = 0
    
    // 底部滚动条
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = option.kBotLineColor
        return scrollLine
    }()
    
    // 底部的分割线
    private lazy var bottomLine : UIView = {
        let botLine = UIView()
        let botH : CGFloat = 0.5
        botLine.backgroundColor = option.kBottomLineColor
        botLine.frame = CGRect(x: 0, y: frame.height-botH, width: frame.width, height: botH)
        return botLine
    }()

    //XBPageOptions给它默认值
    init(frame : CGRect , titles : [String] , options: XBPageOptions?=nil) {
        
        self.titles = titles
        super.init(frame: frame)
        
        if options != nil {
            self.option = options!
        }
        
        setUpAllView()
        
    }
    
    //必须实现
    required init?(coder aDecoder: NSCoder) {
        
//        self.titles = [String]()
//        
//        super.init(coder: aDecoder)
//        
//        self.option = XBPageOptions()
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //进行布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLabelsLayout()
        setupBottomLineLayout()
    }
    
}

extension XBPageTitleView{
    
    private func setUpAllView(){
        
        //添加 scrollerView
        addSubview(scrollView)
        //(0.0, 0.0, 375.0, 42.0)
        scrollView.frame = bounds
        
        //添加对应的 title
        setUpTitleLabel()
        
        // 设置底线滚动的滑块
        setBottomMenuAndScrollLine()
        
        //控制器 option.kGradColors = kGradientColors
        if option.kGradColors != nil {
            
            //设置背景渐变
            let gradientLayer: CAGradientLayer = CAGradientLayer()
            gradientLayer.colors = option.kGradColors
            
            //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
            //渲染的起始位置
            gradientLayer.startPoint = CGPoint.init(x:0,y:0)
            //设置frame 和插入View的layer
            gradientLayer.frame = bounds
            self.layer.insertSublayer(gradientLayer, at: 0)
            
        }
        else{
            scrollView.backgroundColor = option.kscrollViewBGColor
        }
        
        
        
        
    }
    
    private func setUpTitleLabel(){
        
        // for enumerated 打印 index ，title
        for (index,title) in titles.enumerated(){
            
            //创建label
            let lab = UILabel()
            lab.text = title
            lab.tag = index
            
            lab.font = option.kIsNormalFontBold ? BoldFontSize(option.kTitleFontSize) :
            FontSize(option.kTitleFontSize)
            lab.textColor = colorWithRGBA(option.kNormalColor.0, option.kNormalColor.1, option.kNormalColor.2, 1.0)
            lab.textAlignment = .center
            // 添加 lab
            scrollView.addSubview(lab)
            
            titleLabs.append(lab)
            //添加点击事件
            lab.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGesture:)))
            lab.addGestureRecognizer(tap)
            
        }
        
    }
    
    // 添加底部分割线 和 滚动线
    private func setBottomMenuAndScrollLine(){
        
        /**
         控制器中的设置
         option.isShowBottomLine = false
         option.kIsShowBottomBorderLine = true

         **/
        //添加底部分割线
        if option.kIsShowBottomBorderLine{
            addSubview(bottomLine)
        }
        
        //如果没有滚动就返回
        setUpBottomLine()
        
        guard let firstLab = titleLabs.first else {
            return
        }
        
        //设置第一个标题样式
        firstLab.textColor = colorWithRGBA(option.kSelectColor.0, option.kSelectColor.1, option.kSelectColor.2, 1.0)
        
        if option.kTitleSelectFontSize != nil {
            firstLab.font = BoldFontSize(option.kTitleSelectFontSize!)
        }
        
        
        //设置标题是否可以滚动
        adjustLabelPosition(firstLab)
        
        
        
    }
    
    func setUpBottomLine(){
        //使用 guard 语句时，读者和编译器就会知道如果条件为 false，方法将会直接 return
        guard option.isShowBottomLine else {return}
        //添加scrollLine
        scrollLine.addSubview(scrollLine)
        
        
    }
    
    
    
}
//监听label的点击
extension XBPageTitleView{
    
    @objc fileprivate func titleLabelClick(tapGesture : UITapGestureRecognizer) {
        
        // 如果下标相同,不做处理
        if tapGesture.view?.tag == currentIndex {
            return
        }
        // 获取当前 lab 的下标值
        let currentLab = tapGesture.view as? UILabel //else { return }
        
        // 获取之前的label
        let oldLab = titleLabs[currentIndex]
        
        // 切换文字颜色和字体大小
        currentLab?.textColor = colorWithRGBA(option.kSelectColor.0, option.kSelectColor.1, option.kSelectColor.2,  1.0)
        
        oldLab.textColor = colorWithRGBA(option.kNormalColor.0, option.kNormalColor.1, option.kNormalColor.2, 1.0)
        
        // 修改字体大小
        if option.kTitleSelectFontSize != nil{
            currentLab?.font = BoldFontSize (option.kTitleSelectFontSize!)
            oldLab.font = option.kIsNormalFontBold ? BoldFontSize(option.kTitleFontSize) : FontSize(option.kTitleFontSize)
            setupLabelsLayout()
        }
        
        // 保存最新 lab 的下标值
        currentIndex = (currentLab?.tag)!
        
        // 滚动条位置发生改变
        let scrollLineX = CGFloat((currentLab?.tag)!) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        adjustLabelPosition(currentLab!)
        
        if option.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollLine.frame.origin.x = (currentLab?.frame.origin.x)!
                self.scrollLine.frame.size.width = (currentLab?.frame.width)!
            })
        }
        
        //通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }

    
}

// MARK: - layout
extension XBPageTitleView{
    //标题进行布局
    private func setupLabelsLayout(){
        var labelW: CGFloat = 0
        let labelH = frame.size.height
        var labelX: CGFloat = 0
        let labelY: CGFloat = 0
        
        //拿到标题数量
        let count = titleLabs.count
        //进行布局
        for (i,titleLabel) in titleLabs.enumerated() {
            // 是否允许标题滚动
            if option.isTitleScrollEnable{
                //在当前图形上下文中的指定矩形内，计算并返回使用给定选项和显示特征绘制的接收器的边框矩形。
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : titleLabel.font], context: nil).width
                
                //第一个间隔10
                labelX = i == 0 ? option.kMarginW * 0.5 :(titleLabs[i-1].frame.maxX + option.kMarginW)
                
            }
            // 选项宽度
            else if option.kItemWidth != 0{

                labelW = option.kItemWidth
                labelX = labelW * CGFloat(i)
                
            }
            else{
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }
            
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW+Adapt(10), height: labelH)
            
        }
        // 是否允许标题滚动
        if option.isTitleScrollEnable{
            guard let titleLabel = titleLabs.last else{
                return
            }
            //内容视图的大小。
            scrollView.contentSize.width = titleLabel.frame.maxX + option.kMarginW * 0.5
        }
        
        
    }
    
    //bottomLine
    private func setupBottomLineLayout() {
        guard titleLabs.count - 1 >= currentIndex else{ return }
        let label = titleLabs[currentIndex]
        scrollLine.frame.origin.x  = label.frame.origin.x
        scrollLine.frame.size.width = label.frame.width
        scrollLine.frame.size.height = option.kBotLineHeight
        scrollLine.frame.origin.y = self.bounds.height - option.kBotLineHeight
    }
    
    
    // 是否允许标题滚动
    private func adjustLabelPosition(_ targetLabel : UILabel) {
        //是
        guard option.isTitleScrollEnable else {return}
        //0 - 187.5
        var offsetX = targetLabel.center.x - bounds.width * 0.5

        // -187.5
        if offsetX < 0 {
            offsetX = 0
        }
        //scrollView.contentSize.width = 0
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y:0), animated: true)
        
    }
    
    
}




//mark : 对外暴露接口
extension XBPageTitleView{
    
    func setPageTitleWithProgress(progress: CGFloat,  sourceIndex: Int, targetIndex:Int) {
        //取得 labe
        let sourceLab = titleLabs[sourceIndex]
        let targetLab = titleLabs[targetIndex]
        
        
        //处理滑块
        let movtotalX = targetLab.frame.origin.x - sourceLab.frame.origin.x
        let movX = movtotalX * progress
        scrollLine.frame.origin.x = sourceLab.frame.origin.x + movX
        
        // 颜色的渐变
        // 取出颜色变化的范围
        let colorDelta = (option.kSelectColor.0 - option.kNormalColor.0, option.kSelectColor.1 - option.kNormalColor.1, option.kSelectColor.2 - option.kNormalColor.2)
        
        // 变化 sourceLab 的文字颜色
        sourceLab.textColor = colorWithRGBA(option.kSelectColor.0 - colorDelta.0 * progress, option.kSelectColor.1 - colorDelta.1 * progress, option.kSelectColor.2 - colorDelta.2 * progress, 1.0)
        
        
        // 变化 targetLab 的文字颜色
        targetLab.textColor = colorWithRGBA(option.kNormalColor.0 + colorDelta.0 * progress, option.kNormalColor.1 + colorDelta.1 * progress, option.kNormalColor.2 + colorDelta.2 * progress, 1.0)
        if option.kTitleSelectFontSize != nil{
            sourceLab.font = option.kIsNormalFontBold ? BoldFontSize(option.kTitleSelectFontSize! - (option.kTitleSelectFontSize! - option.kTitleFontSize) * progress) : FontSize(option.kTitleSelectFontSize! - (option.kTitleSelectFontSize! - option.kTitleFontSize) * progress)
            targetLab.font = BoldFontSize (option.kTitleSelectFontSize! + (option.kTitleSelectFontSize! - option.kTitleFontSize)  * progress)
            setupLabelsLayout()
        }
        
        // 底部滚动条滚动
        adjustLabelPosition(targetLab)

        if option.isShowBottomLine {
            let deltaX = targetLab.frame.origin.x - sourceLab.frame.origin.x
            let deltaW = targetLab.frame.width - sourceLab.frame.width
            scrollLine.frame.origin.x = sourceLab.frame.origin.x + progress * deltaX
            scrollLine.frame.size.width = sourceLab.frame.width + progress * deltaW
        }
        // 记录最新的 index
        currentIndex = targetIndex

        
        
    }
    
    
}
