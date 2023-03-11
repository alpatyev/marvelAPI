import UIKit
import SnapKit

// MARK: - Custom cel

class MarvelCell: UITableViewCell {
    
    static let id = "MarvelCell"

    // MARK: - UI
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Constants.Colors.white
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.Layout.defaultHeight * 0.75 * 0.9
        imageView.backgroundColor = Constants.Colors.hardTint
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.main
        label.font = Constants.Fonts.monospaced
        return label
    }()
    
    // MARK: - Configuration
    
    public func configure(with text: String, _ data: Data? = nil) {
        if let imageData = data {
            icon.image = UIImage(data: imageData)
        }
        nameLabel.text = text
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        icon.image = nil
        nameLabel.text = nil
    }
    
    // MARK: - Setups
    
    private func setupView() {
        backgroundColor = Constants.Colors.black
    }
    
    private func setupHierarchy() {
        addSubview(icon)
        addSubview(nameLabel)
    }
    
    private func setupLayout() {
        icon.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalTo(icon.snp.height)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.Layout.indent)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(Constants.Layout.indent)
            make.right.equalToSuperview().inset(Constants.Layout.indent * 2)
            make.height.centerY.equalToSuperview()
        }
    }
}
